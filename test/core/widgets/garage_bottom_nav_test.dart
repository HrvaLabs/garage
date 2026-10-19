import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/garage_sidebar.dart';
import 'package:garage/core/widgets/page_header.dart';
import 'package:garage/domain/entities/household.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../../support/pump_screen.dart';

Future<NavigationLog> pumpNav(
  WidgetTester tester, {
  Locale? locale,
  Size surface = const Size(360, 800),
  GarageTab current = GarageTab.dashboard,
}) {
  return pumpScreen(
    tester,
    GarageTabScaffold(
      current: current,
      appBar: AppBar(title: const Text('Screen')),
      body: const SizedBox(),
    ),
    surface: surface,
    locale: locale,
  );
}

List<String> tabLabels(AppLocalizations l10n) => [
  l10n.dashboardTitle,
  l10n.timelineTitle,
  l10n.vehiclesTitle,
  l10n.companyDriverCarsTab,
  l10n.plannerTitle,
  l10n.settingsTitle,
];

void main() {
  testWidgets('every tab is offered', (tester) async {
    await pumpNav(tester);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });

  testWidgets('the current tab is the selected one', (tester) async {
    await pumpNav(tester, current: GarageTab.planner);
    await tester.pumpAndSettle();

    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));

    expect(bar.selectedIndex, 3);
  });

  testWidgets('a phone-width window uses the bottom bar', (tester) async {
    await pumpNav(tester, surface: const Size(400, 900));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(GarageSidebar), findsNothing);
  });

  testWidgets('a desktop-width window uses the sidebar instead', (
    tester,
  ) async {
    await pumpNav(tester, surface: const Size(1400, 900));
    await tester.pumpAndSettle();

    expect(find.byType(GarageSidebar), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  group('a driver\'s cars tab', () {
    // A driver's list is titled "My cars": the cars handed to them, none of
    // them theirs to add. The tab that opens it said "Vehicles", the
    // everyday word for a garage's own, and two words do not fit a tab.
    Future<void> pumpAs(
      WidgetTester tester,
      String role, {
      Size surface = const Size(360, 800),
    }) async {
      await pumpScreen(
        tester,
        GarageTabScaffold(
          current: GarageTab.vehicles,
          appBar: AppBar(title: const Text('Screen')),
          body: const SizedBox(),
        ),
        surface: surface,
        household: const Household(id: 'h1', name: 'Prijevoz', plan: 'company'),
        role: role,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('says Cars to a driver', (tester) async {
      await pumpAs(tester, 'driver');

      expect(find.text('Cars'), findsOneWidget);
      expect(find.text('Vehicles'), findsNothing);
    });

    testWidgets('and still says Vehicles to everybody else', (tester) async {
      await pumpAs(tester, 'member');

      expect(find.text('Vehicles'), findsOneWidget);
      expect(find.text('Cars'), findsNothing);
    });

    testWidgets('in the sidebar too', (tester) async {
      await pumpAs(tester, 'driver', surface: const Size(1400, 900));

      expect(
        find.descendant(
          of: find.byType(GarageSidebar),
          matching: find.text('Cars'),
        ),
        findsOneWidget,
      );
      expect(find.text('Vehicles'), findsNothing);
    });
  });

  testWidgets('tapping a tab navigates to it', (tester) async {
    final log = await pumpNav(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.event_note_outlined));
    await tester.pumpAndSettle();

    expect(log.visited, contains('/planner'));
  });

  testWidgets('tapping the current tab navigates nowhere', (tester) async {
    final log = await pumpNav(tester, current: GarageTab.dashboard);
    await tester.pumpAndSettle();
    final before = log.visited.length;

    await tester.tap(find.byIcon(Icons.dashboard));
    await tester.pumpAndSettle();

    expect(log.visited, hasLength(before));
  });

  // A tab slot is barely wider than one word. A label containing a space wraps
  // onto a second line, making that one destination taller than its
  // neighbours — the Croatian timeline label used to do exactly this.
  group('tab labels stay on one line', () {
    for (final locale in AppLocalizations.supportedLocales) {
      test('in ${locale.languageCode}', () {
        final l10n = lookupAppLocalizations(locale);

        for (final label in tabLabels(l10n)) {
          expect(
            label.trim(),
            isNot(contains(' ')),
            reason:
                '"$label" is more than one word, so it wraps in the tab bar',
          );
        }
      });
    }
  });

  group('page chrome', () {
    Future<void> pumpTitled(WidgetTester tester, Size surface) {
      return pumpScreen(
        tester,
        const GarageTabScaffold(
          current: GarageTab.dashboard,
          title: 'Fuel',
          body: SizedBox(),
        ),
        surface: surface,
      );
    }

    testWidgets('a desktop window titles the page in its content', (
      tester,
    ) async {
      await pumpTitled(tester, const Size(1400, 900));
      await tester.pumpAndSettle();

      expect(find.byType(PageHeader), findsOneWidget);
      expect(
        find.byType(AppBar),
        findsNothing,
        reason: 'a top bar above a sidebar is phone chrome on a desktop window',
      );
    });

    testWidgets('and the top bar runs the width of the pane', (tester) async {
      await pumpTitled(tester, desktopSurface);
      await tester.pumpAndSettle();

      // Sidebar 240 and its rule 1: the rest of a 1440 window is the pane.
      expect(tester.getSize(find.byType(PageHeader)).width, 1440 - 241);
    });

    testWidgets('a phone keeps the app bar', (tester) async {
      await pumpTitled(tester, const Size(400, 900));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(PageHeader), findsNothing);
    });

    testWidgets('the title is shown either way', (tester) async {
      for (final surface in [const Size(1400, 900), const Size(400, 900)]) {
        await pumpTitled(tester, surface);
        await tester.pumpAndSettle();

        expect(find.text('Fuel'), findsOneWidget);
      }
    });
  });
}
