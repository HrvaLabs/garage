import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/theme/garage_theme.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/page_header.dart';
import 'package:garage/core/widgets/page_scaffold.dart';
import 'package:garage/core/widgets/pointer_anchor.dart';
import 'package:garage/features/dashboard/quick_add.dart';
import 'package:garage/features/dashboard/widgets/quick_add_button.dart';
import 'package:garage/features/fuel/providers/fuel_providers.dart';
import 'package:garage/features/fuel/providers/pump_providers.dart';
import 'package:garage/features/odometer/providers/odometer_providers.dart';
import 'package:garage/features/stations/providers/station_providers.dart';

import '../../support/pump_screen.dart';

/// A page whose keys include N for the quick-add, as a desk's shortcuts give
/// every page: the focus on the whole page, which holds the keys.
Widget _nOpensTheQuickAdd() => Consumer(
  builder: (context, ref, _) => CallbackShortcuts(
    bindings: {
      const SingleActivator(LogicalKeyboardKey.keyN): () =>
          showQuickAdd(context, ref),
    },
    child: const Focus(autofocus: true, child: SizedBox.expand()),
  ),
);

/// The dashboard's + was the one place to log anything; on a desk it is in
/// every page's top bar, so a fill-up can be added from the console or the
/// statistics without going back to the dashboard.
void main() {
  testWidgets('every page on a desk offers it', (tester) async {
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('top-bar-quick-add')));
    await tester.pumpAndSettle();

    expect(find.text('Fill-up'), findsOneWidget);
    expect(find.text('Service'), findsOneWidget);
  });

  testWidgets('it is the bar\'s outlined button, not a page\'s filled one', (
    tester,
  ) async {
    // A page's own act is the filled button beside it. In the same fill they
    // read as one offer made twice.
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    final button = tester.widget(find.byKey(const Key('top-bar-quick-add')));
    expect(button, isA<OutlinedButton>());
    expect((button as OutlinedButton).style, GarageTheme.toolbarButton);
  });

  testWidgets('both top bars key it, to keep it itself beside a page\'s act', (
    tester,
  ) async {
    // Matched by its key, it does not depend on what joins the bar beside it.
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(PageHeader),
        matching: find.byKey(const ValueKey(QuickAddButton)),
      ),
      findsOneWidget,
    );

    await pumpDesktop(
      tester,
      const GarageTabScaffold(
        current: GarageTab.timeline,
        title: 'Timeline',
        body: SizedBox(),
      ),
      initialLocation: '/timeline',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(PageHeader),
        matching: find.byKey(const ValueKey(QuickAddButton)),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a garage with no car is not offered it', (tester) async {
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
      initialLocation: '/stats',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('top-bar-quick-add')), findsNothing);
  });

  testWidgets('a phone keeps it on the dashboard only', (tester) async {
    await pumpScreen(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('top-bar-quick-add')), findsNothing);
  });

  testWidgets('a tab offers it in its top bar too', (tester) async {
    await pumpDesktop(
      tester,
      const GarageTabScaffold(
        current: GarageTab.timeline,
        title: 'Timeline',
        body: SizedBox(),
      ),
      initialLocation: '/timeline',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(PageHeader),
        matching: find.byKey(const Key('top-bar-quick-add')),
      ),
      findsOneWidget,
    );
  });

  testWidgets('what is picked opens on the page it was asked from', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
      // What the fill-up sheet reads, which no fake behind the harness gives.
      overrides: [
        rawFuelEntriesProvider('v1').overrideWith((ref) async => const []),
        rawOdometerSamplesProvider('v1').overrideWith((ref) async => const []),
        stationAtThePumpProvider.overrideWith((ref, query) async => null),
        stationsProvider.overrideWith((ref) async => const []),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('top-bar-quick-add')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fill-up'));
    await tester.pumpAndSettle();

    expect(find.text('Log a fill-up'), findsOneWidget);
  });

  group('where it opens', () {
    setUp(PointerAnchor.reset);

    Rect card(WidgetTester tester) =>
        tester.getRect(find.byKey(const Key('anchored-popover')));

    testWidgets('pressed, it hangs from Add itself, as a button\'s menu '
        'does', (tester) async {
      // Hung from the press inside the button, the card covered the lower
      // half of the button that opened it.
      await pumpDesktop(
        tester,
        const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
        initialLocation: '/stats',
        vehicles: [testVehicle('v1')],
      );
      await tester.pumpAndSettle();
      final add = find.byKey(const Key('top-bar-quick-add'));
      // Off the button's centre, so a card hung from the press would show.
      final click = tester.getTopLeft(add) + const Offset(12, 10);

      await tester.tapAt(click);
      await tester.pumpAndSettle();

      // Add is at the bar's far end, with no room to its right: the card
      // ends where Add ends, below it.
      expect(card(tester).top, closeTo(tester.getRect(add).bottom, 1));
      expect(card(tester).right, closeTo(tester.getRect(add).right, 1));
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('from a key, it hangs from the bar\'s Add', (tester) async {
      // The key's own place is no help: what has the focus then is the page
      // that holds the keys, and its corner is the window's.
      await pumpDesktop(
        tester,
        GaragePageScaffold(title: 'Statistics', body: _nOpensTheQuickAdd()),
        initialLocation: '/stats',
        vehicles: [testVehicle('v1')],
      );
      await tester.pumpAndSettle();
      // A press somewhere else first: the key must not reuse it.
      await tester.tapAt(const Offset(700, 500));

      await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
      await tester.pumpAndSettle();

      final add = tester.getRect(find.byKey(const Key('top-bar-quick-add')));
      expect(card(tester).top, closeTo(add.bottom, 1));
      expect(card(tester).right, closeTo(add.right, 1));
      expect(find.text('Fill-up'), findsOneWidget);
    });

    testWidgets('on the web with the accessibility layer on, a click on Add '
        'hangs it from Add, not from an older press', (tester) async {
      // A click there reaches the app as an accessibility tap, with no
      // press, and the last press it saw was the sign-in form's password
      // field: the card opened in the middle of the page.
      PointerAnchor.web = true;
      addTearDown(() => PointerAnchor.web = kIsWeb);
      await pumpDesktop(
        tester,
        const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
        initialLocation: '/stats',
        vehicles: [testVehicle('v1')],
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(700, 500));

      tester.semantics.tap(find.semantics.byLabel('Add'));
      await tester.pumpAndSettle();

      final add = tester.getRect(find.byKey(const Key('top-bar-quick-add')));
      expect(card(tester).top, closeTo(add.bottom, 1));
      expect(card(tester).right, closeTo(add.right, 1));
    });

    testWidgets('and the car it asks for next hangs there too', (tester) async {
      await pumpDesktop(
        tester,
        GaragePageScaffold(title: 'Statistics', body: _nOpensTheQuickAdd()),
        initialLocation: '/stats',
        vehicles: [testVehicle('v1'), testVehicle('v2')],
      );
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
      await tester.pumpAndSettle();

      // Into the card and onto its first tile, Fill-up, by the keyboard.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Which vehicle?'), findsOneWidget);
      final add = tester.getRect(find.byKey(const Key('top-bar-quick-add')));
      expect(card(tester).top, closeTo(add.bottom, 1));
      expect(card(tester).right, closeTo(add.right, 1));
    });
  });

  testWidgets('its three tiles keep a card\'s outline on a desk', (
    tester,
  ) async {
    // The desk's theme draws a card as a row with a rule under it, which
    // made the three read as underlined labels side by side, a tab strip,
    // until one was hovered.
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: SizedBox()),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('top-bar-quick-add')));
    await tester.pumpAndSettle();

    for (final label in ['Fill-up', 'Service', 'Cost']) {
      final tile = find.ancestor(
        of: find.text(label),
        matching: find.byType(Card),
      );
      final surface = tester.widget<Material>(
        find.descendant(of: tile, matching: find.byType(Material)).first,
      );
      expect(
        surface.shape,
        GarageTheme.light().cardTheme.shape,
        reason: '$label is a tile, outlined as a card is on a phone',
      );
      expect(
        surface.clipBehavior,
        Clip.antiAlias,
        reason: 'a hovered tile fills to its rounded corners, not past them',
      );
    }
  });
}
