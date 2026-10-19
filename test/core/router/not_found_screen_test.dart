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
import 'package:garage/features/household/providers/household_providers.dart';
import 'package:garage/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}
