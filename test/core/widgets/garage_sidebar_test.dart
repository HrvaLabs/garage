import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/garage_sidebar.dart';
import 'package:garage/core/widgets/page_scaffold.dart';
import 'package:garage/domain/entities/household.dart';
import 'package:go_router/go_router.dart';

import '../../support/pump_screen.dart';

const _company = Household(id: 'h1', name: 'Prijevoz', plan: 'company');

Future<NavigationLog> pumpTab(
  WidgetTester tester, {
  Size surface = desktopSurface,
  Household household = testHousehold,
  String role = 'admin',
  Locale? locale,
}) async {
  final log = await pumpDesktop(
    tester,
    // Titled "Page" so the only "Dashboard" on screen is the sidebar's.
    const GarageTabScaffold(
      current: GarageTab.dashboard,
      title: 'Page',
      body: SizedBox(),
    ),
    surface: surface,
    household: household,
    role: role,
    locale: locale,
    extraRoutes: const [
      '/household',
      '/trips',
      '/routes',
      '/tour',
      '/data',
      '/about',
    ],
  );
  await tester.pumpAndSettle();
  return log;
}

/// A pushed page at [location], the sidebar drawn beside it.
Future<NavigationLog> pumpPageAt(
  WidgetTester tester,
  String location, {
  Iterable<String> extraRoutes = const [],
}) async {
  final log = await pumpDesktop(
    tester,
    const GaragePageScaffold(title: 'Page', body: SizedBox()),
    initialLocation: location,
    extraRoutes: extraRoutes,
  );
  await tester.pumpAndSettle();
  return log;
}

double _top(WidgetTester tester, String label) =>
    tester.getTopLeft(find.text(label)).dy;

/// Whether the sidebar marks the link to [route] as where the page is.
bool _lit(WidgetTester tester, String route) => tester
    .widget<Semantics>(
      find
          .ancestor(
            of: find.byKey(Key('sidebar-$route')),
            matching: find.byType(Semantics),
          )
          .first,
    )
    .properties
    .selected!;

void main() {
  group('which link a page belongs under', () {
    const links = [
      SidebarLink('Dashboard', Icons.abc, '/', tab: true),
      SidebarLink('Vehicles', Icons.abc, '/vehicles', tab: true),
      SidebarLink('Garage', Icons.abc, '/household'),
      SidebarLink('Statistics', Icons.abc, '/stats'),
    ];

    test('its own route', () {
      expect(currentLink(links, '/stats')?.label, 'Statistics');
    });
    test('the route it sits under', () {
      expect(currentLink(links, '/vehicles/v1/fuel')?.label, 'Vehicles');
      expect(currentLink(links, '/household/merge')?.label, 'Garage');
    });
    test('the dashboard only for itself, not for every address', () {
      expect(currentLink(links, '/')?.label, 'Dashboard');
      expect(currentLink(links, '/pending'), isNull);
    });
    test('a prefix of a word is not a parent', () {
      expect(currentLink(links, '/statsx'), isNull);
    });
  });

  testWidgets('a desk gets the labelled sidebar, 240 pixels wide', (
    tester,
  ) async {
    await pumpTab(tester);

    expect(tester.getSize(find.byType(GarageSidebar)).width, 240);
    expect(find.text('Statistics'), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('between 900 and 1200 it is icons, named on hover', (
    tester,
  ) async {
    await pumpTab(tester, surface: const Size(1000, 800));

    expect(tester.getSize(find.byType(GarageSidebar)).width, 72);
    expect(find.text('Statistics'), findsNothing);
    expect(find.byTooltip('Statistics'), findsOneWidget);
  });

  testWidgets('the five primaries, then the tools, then the bottom group', (
    tester,
  ) async {
    await pumpTab(tester);

    final order = [
      'Dashboard',
      'Timeline',
      'Vehicles',
      'Planner',
      'Garage',
      'Statistics',
      'Trips',
      'Routes',
      'Fuel stations',
      'Calculator',
      'What Garage can do',
      'Settings',
      'Your data',
      'About',
    ];
    for (var i = 1; i < order.length; i++) {
      expect(
        _top(tester, order[i - 1]),
        lessThan(_top(tester, order[i])),
        reason: '${order[i - 1]} above ${order[i]}',
      );
    }
    // A sidebar with room for everything has nothing to fold into "More".
    expect(find.text('More'), findsNothing);
  });

  testWidgets('leads the tools with the console for an admin on the plan', (
    tester,
  ) async {
    await pumpTab(tester, household: _company);

    expect(_top(tester, 'Company'), lessThan(_top(tester, 'Statistics')));
    expect(_top(tester, 'Company'), greaterThan(_top(tester, 'Garage')));
  });

  testWidgets('and keeps it off a driver\'s', (tester) async {
    await pumpTab(tester, household: _company, role: 'driver');

    expect(find.text('Company'), findsNothing);
  });

  testWidgets('names the garage at the top and the person at the bottom', (
    tester,
  ) async {
    await pumpTab(tester);

    expect(find.text(testHousehold.name), findsOneWidget);
    expect(find.text('Karlo'), findsOneWidget);
    expect(_top(tester, 'Karlo'), greaterThan(_top(tester, 'About')));
  });

  // What is on screen, not the navigation log's last entry: go_router builds
  // the page under a pushed one again, so the log ends on that page.
  testWidgets('a tool is pushed and a tab is gone to', (tester) async {
    await pumpTab(tester);

    await tester.tap(find.byKey(const Key('sidebar-/stats')));
    await tester.pumpAndSettle();
    expect(find.text('stub:/stats'), findsOneWidget);
    final router = GoRouter.of(tester.element(find.text('stub:/stats')));
    expect(
      router.canPop(),
      isTrue,
      reason: 'pushed: the page it was opened from is underneath, for back',
    );

    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sidebar-/timeline')));
    await tester.pumpAndSettle();
    expect(find.text('stub:/timeline'), findsOneWidget);
    expect(
      router.canPop(),
      isFalse,
      reason: 'gone to: a tab replaces the page rather than covering it',
    );
  });

  testWidgets('the person opens Settings', (tester) async {
    await pumpTab(tester);

    await tester.tap(find.byKey(const Key('sidebar-account')));
    await tester.pumpAndSettle();
    expect(find.text('stub:/settings'), findsOneWidget);
  });

  testWidgets('and does nothing on Settings itself', (tester) async {
    final log = await pumpPageAt(tester, '/settings');
    final before = log.visited.length;

    await tester.tap(find.byKey(const Key('sidebar-account')));
    await tester.pumpAndSettle();

    expect(log.visited, hasLength(before));
    expect(
      GoRouter.of(tester.element(find.byType(GarageSidebar))).canPop(),
      isFalse,
      reason: 'a second Settings pushed onto the first',
    );
  });

  testWidgets('a pushed page lights the link it sits under', (tester) async {
    await pumpPageAt(tester, '/stats');

    expect(_lit(tester, '/stats'), isTrue);
    expect(_lit(tester, '/'), isFalse);
  });

  group('a lit link', () {
    testWidgets('does nothing on the page it names', (tester) async {
      final log = await pumpPageAt(tester, '/stats');
      final before = log.visited.length;

      await tester.tap(find.byKey(const Key('sidebar-/stats')));
      await tester.pumpAndSettle();

      expect(log.visited, hasLength(before));
      expect(
        GoRouter.of(tester.element(find.byType(GarageSidebar))).canPop(),
        isFalse,
        reason: 'a second Statistics pushed onto the first',
      );
    });

    testWidgets('opens its tab from a page under it', (tester) async {
      final log = await pumpPageAt(tester, '/vehicles/v1/fuel');
      expect(_lit(tester, '/vehicles'), isTrue);

      await tester.tap(find.byKey(const Key('sidebar-/vehicles')));
      await tester.pumpAndSettle();

      expect(log.last, '/vehicles');
    });

    testWidgets('and its section, when the section is not a tab', (
      tester,
    ) async {
      await pumpPageAt(
        tester,
        '/household/merge',
        extraRoutes: const ['/household'],
      );
      expect(_lit(tester, '/household'), isTrue);

      await tester.tap(find.byKey(const Key('sidebar-/household')));
      await tester.pumpAndSettle();

      expect(find.text('stub:/household'), findsOneWidget);
    });
  });

  for (final surface in const [Size(1024, 768), Size(1280, 720)]) {
    testWidgets('lays out at ${surface.width.toInt()}x'
        '${surface.height.toInt()} without overflow', (tester) async {
      await pumpTab(tester, surface: surface, household: _company);

      expect(tester.takeException(), isNull);
    });
  }

  // The tab strip's lesson (decision 173): a label cut to fit throws
  // nothing, so only measuring in the app's own font finds it.
  group('every label fits, in every language', () {
    setUpAll(() async {
      final inter = FontLoader('Inter')
        ..addFont(rootBundle.load('fonts/InterDisplay-Regular.ttf'))
        ..addFont(rootBundle.load('fonts/InterDisplay-Medium.ttf'))
        ..addFont(rootBundle.load('fonts/InterDisplay-SemiBold.ttf'));
      await inter.load();
    });

    for (final locale in const [Locale('en'), Locale('hr'), Locale('it')]) {
      testWidgets(locale.languageCode, (tester) async {
        await pumpTab(tester, household: _company, locale: locale);

        final cut = [
          for (final element
              in find
                  .descendant(
                    of: find.byType(GarageSidebar),
                    matching: find.byType(RichText),
                  )
                  .evaluate())
            if (element.renderObject case final RenderParagraph paragraph
                when paragraph.size.width + 0.5 <
                    paragraph.getMaxIntrinsicWidth(double.infinity))
              paragraph.text.toPlainText(),
        ];
        expect(cut, isEmpty);
      });
    }
  });
}
