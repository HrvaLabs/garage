import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/errors/failure_log.dart';
import 'package:garage/core/localization/garage_localizations.dart';
import 'package:garage/core/router/app_router.dart';
import 'package:garage/core/router/not_found_screen.dart';
import 'package:garage/core/supabase/supabase_client_provider.dart';
import 'package:garage/core/sync/read_cache_providers.dart';
import 'package:garage/core/sync/read_cache_store.dart';
import 'package:garage/core/widgets/app_frame.dart';
import 'package:garage/core/widgets/garage_sidebar.dart';
import 'package:garage/features/household/data/garage_bootstrap_cache.dart';
import 'package:garage/features/household/providers/household_providers.dart';
import 'package:garage/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../support/fake_repositories.dart';
import '../../support/pump_screen.dart';

/// An address nothing in the route table matches: a mistyped web address, a
/// link from an older version, or a launcher shortcut that lost its URL —
/// which is how "Page Not Found" reached a phone in October 2026.
void main() {
  testWidgets('says so in the app\'s language, not go_router\'s', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      const NotFoundScreen(path: '/@2131689530'),
      initialLocation: '/@2131689530',
      locale: const Locale('hr'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ovdje nema ničega'), findsWidgets);
    expect(find.textContaining('Page Not Found'), findsNothing);
    expect(find.textContaining('GoException'), findsNothing);
  });

  testWidgets('and offers the way back to the dashboard', (tester) async {
    final log = await pumpScreen(
      tester,
      const NotFoundScreen(path: '/no-such-page'),
      initialLocation: '/no-such-page',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('not-found-home')));
    await tester.pumpAndSettle();

    expect(log.visited.last, '/');
  });

  testWidgets('records which address it was', (tester) async {
    // The shortcut bug was diagnosed from a screenshot; the address is what
    // Diagnostics can hand over instead.
    await pumpScreen(
      tester,
      const NotFoundScreen(path: '/no-such-page'),
      initialLocation: '/no-such-page',
    );
    await tester.pumpAndSettle();

    expect(recordedFailures.last, contains('no page at /no-such-page'));
  });

  testWidgets('fits a 320-pixel phone in Croatian at 1.5x', (tester) async {
    await pumpScreen(
      tester,
      const NotFoundScreen(path: '/no-such-page'),
      initialLocation: '/no-such-page',
      locale: const Locale('hr'),
      textScale: 1.5,
      surface: const Size(320, 640),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('the app\'s router opens it for an address nothing matches', (
    tester,
  ) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        '/no-such-page?token=secret';
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );
    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWithValue(
          const User(
            id: 'u1',
            appMetadata: {},
            userMetadata: {},
            aud: 'authenticated',
            createdAt: '2026-01-01T00:00:00Z',
          ),
        ),
        currentHouseholdProvider.overrideWith(
          (ref) => Future.value(testHousehold),
        ),
        readCacheStoreProvider.overrideWithValue(const NoReadCacheStore()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          localizationsDelegates: garageLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(appRouterProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final page = tester.widget<NotFoundScreen>(find.byType(NotFoundScreen));
    expect(page.path, '/no-such-page', reason: 'the path, never the query');
  });

  testWidgets('on a desk it keeps the sidebar and lights nothing in it', (
    tester,
  ) async {
    // go_router builds this page with no route state behind it, which is
    // what the sidebar reads to know where a page is.
    await pumpDeskAt(tester, '/no-such-page');

    expect(tester.takeException(), isNull);
    expect(find.byType(NotFoundScreen), findsOneWidget);
    expect(find.byType(GarageSidebar), findsOneWidget);
    final lit = [
      for (final semantics in tester.widgetList<Semantics>(
        find.descendant(
          of: find.byType(GarageSidebar),
          matching: find.byType(Semantics),
        ),
      ))
        if (semantics.properties.selected ?? false) semantics.properties.label,
    ];
    expect(lit, isEmpty, reason: 'no link holds an address nothing matches');
  });

  // go_router builds a push from the configuration it is showing, its error
  // included, and draws this page again: pushed, a link went nowhere.
  group('on a desk the sidebar leads away from it', () {
    testWidgets('by a link that is not a tab', (tester) async {
      final router = await pumpDeskAt(tester, '/no-such-page');

      await tester.tap(find.byKey(const Key('sidebar-/tour')));
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundScreen), findsNothing);
      expect(router.routerDelegate.currentConfiguration.isError, isFalse);
      expect(router.routerDelegate.currentConfiguration.uri.path, '/tour');
    });

    testWidgets('and by the person, to Settings', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final router = await pumpDeskAt(tester, '/no-such-page');

      await tester.tap(find.byKey(const Key('sidebar-account')));
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundScreen), findsNothing);
      expect(router.routerDelegate.currentConfiguration.isError, isFalse);
      expect(router.routerDelegate.currentConfiguration.uri.path, '/settings');
    });
  });
}

/// The app's own router and frame in a desk's window, opened at [address].
Future<GoRouter> pumpDeskAt(WidgetTester tester, String address) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = desktopSurface;
  addTearDown(tester.view.reset);
  tester.binding.platformDispatcher.defaultRouteNameTestValue = address;
  addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
  final container = ProviderContainer(
    overrides: [
      currentUserProvider.overrideWithValue(
        const User(
          id: 'u1',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: '2026-01-01T00:00:00Z',
        ),
      ),
      currentHouseholdProvider.overrideWith(
        (ref) => Future.value(testHousehold),
      ),
      readCacheStoreProvider.overrideWithValue(const NoReadCacheStore()),
      garageBootstrapRepositoryProvider.overrideWithValue(
        FakeGarageBootstrapRepository(roles: {testHousehold.id: 'admin'}),
      ),
      garageBootstrapCacheProvider.overrideWithValue(
        const NoGarageBootstrapCache(),
      ),
    ],
  );
  addTearDown(container.dispose);
  final router = container.read(appRouterProvider);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        localizationsDelegates: garageLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => GarageAppFrame(child: child!),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}
