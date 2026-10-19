import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/page_header.dart';
import 'package:garage/core/widgets/page_scaffold.dart';
import 'package:garage/core/widgets/primary_action.dart';

import '../../support/floating_button.dart';
import '../../support/pump_screen.dart';

var _pressed = 0;
final _action = PrimaryAction(
  key: const Key('log-fuel'),
  label: 'Log a fill-up',
  icon: Icons.local_gas_station_outlined,
  onPressed: () => _pressed++,
);

/// A + that opens a choice, as the maintenance screen's does.
final _menu = PrimaryAction(
  key: const Key('menu-add'),
  label: 'Add',
  icon: Icons.add,
  extended: false,
  onPressed: () => _pressed++,
);

Finder _inTopBar(Finder finder) =>
    find.descendant(of: find.byType(PageHeader), matching: finder);

void main() {
  setUp(() => _pressed = 0);

  testWidgets('a phone gets a floating button', (tester) async {
    await pumpScreen(
      tester,
      GaragePageScaffold(
        title: 'Fuel',
        primaryAction: _action,
        body: const SizedBox(),
      ),
      initialLocation: '/vehicles/v1/fuel',
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.byKey(const Key('log-fuel')));
    expect(_pressed, 1);
  });

  testWidgets('a desk gets it in the top bar, and no floating button', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      GaragePageScaffold(
        title: 'Fuel',
        primaryAction: _action,
        body: const SizedBox(),
      ),
      initialLocation: '/vehicles/v1/fuel',
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(_inTopBar(find.byKey(const Key('log-fuel'))), findsOneWidget);
    await tester.tap(find.byKey(const Key('log-fuel')));
    expect(_pressed, 1);
  });

  testWidgets('a tab\'s top bar carries it too', (tester) async {
    await pumpDesktop(
      tester,
      GarageTabScaffold(
        current: GarageTab.vehicles,
        title: 'Vehicles',
        primaryAction: _action,
        body: const SizedBox(),
      ),
      initialLocation: '/vehicles',
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(_inTopBar(find.byKey(const Key('log-fuel'))), findsOneWidget);
    await tester.tap(find.byKey(const Key('log-fuel')));
    expect(_pressed, 1);
  });

  testWidgets('and floats on a phone', (tester) async {
    await pumpScreen(
      tester,
      GarageTabScaffold(
        current: GarageTab.vehicles,
        title: 'Vehicles',
        primaryAction: _action,
        body: const SizedBox(),
      ),
      initialLocation: '/vehicles',
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(PageHeader), findsNothing);
  });

  testWidgets('on a desk it is the page\'s filled button, and Add is not', (
    tester,
  ) async {
    // Add is in every top bar and a page's own act in some of them: two
    // buttons in the same fill, side by side, would read as one offer twice.
    await pumpDesktop(
      tester,
      GaragePageScaffold(
        title: 'Fuel',
        primaryAction: _action,
        body: const SizedBox(),
      ),
      initialLocation: '/vehicles/v1/fuel',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    final own = find.byKey(const Key('log-fuel'));
    final add = find.byKey(const Key('top-bar-quick-add'));
    expect(tester.widget(own), isA<FilledButton>());
    expect(tester.widget(add), isA<OutlinedButton>());

    Color? fill(Finder button) => tester
        .widget<Material>(
          find.descendant(of: button, matching: find.byType(Material)).first,
        )
        .color;
    expect(fill(add), isNot(fill(own)));
    // The page's own act, then what every page offers, at the bar's end.
    expect(tester.getTopRight(own).dx, lessThan(tester.getTopLeft(add).dx));
  });

  testWidgets('an act the top bar already offers is not offered twice', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      GaragePageScaffold(
        title: 'Fuel',
        primaryAction: PrimaryAction(
          key: const Key('own-add'),
          label: 'Add',
          icon: Icons.add,
          showOnWide: false,
          onPressed: () {},
        ),
        body: const SizedBox(),
      ),
      initialLocation: '/vehicles/v1/fuel',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('own-add')), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  group('a phone\'s button is the one each screen built itself', () {
    testWidgets('a labelled one carries its label and no tooltip', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        GaragePageScaffold(
          title: 'Fuel',
          primaryAction: _action,
          body: const SizedBox(),
        ),
        initialLocation: '/vehicles/v1/fuel',
      );
      await tester.pumpAndSettle();

      expectFloatingButton(
        tester,
        key: const Key('log-fuel'),
        label: 'Log a fill-up',
        icon: Icons.local_gas_station_outlined,
      );
    });

    testWidgets('a bare + gains no tooltip and no name it did not have', (
      tester,
    ) async {
      // The label is for the desk's button. The dashboard's + and the
      // maintenance screen's had neither a tooltip nor a spoken name.
      final semantics = tester.ensureSemantics();
      await pumpScreen(
        tester,
        GaragePageScaffold(
          title: 'Upkeep',
          primaryAction: _menu,
          body: const SizedBox(),
        ),
        initialLocation: '/vehicles/v1/maintenance',
      );
      await tester.pumpAndSettle();

      expectFloatingButton(
        tester,
        key: const Key('menu-add'),
        label: 'Add',
        icon: Icons.add,
        extended: false,
      );
      expect(find.byTooltip('Add'), findsNothing);
      expect(find.bySemanticsLabel('Add'), findsNothing);
      semantics.dispose();
    });

    testWidgets('and on a desk it is labelled', (tester) async {
      await pumpDesktop(
        tester,
        GaragePageScaffold(
          title: 'Upkeep',
          primaryAction: _menu,
          body: const SizedBox(),
        ),
        initialLocation: '/vehicles/v1/maintenance',
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: _inTopBar(find.byKey(const Key('menu-add'))),
          matching: find.text('Add'),
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('a tab\'s own action sits above the tab on a desk', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      ActionPane(action: _action, body: const Text('tab')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(
      tester.getTopLeft(find.byKey(const Key('log-fuel'))).dy,
      lessThan(tester.getTopLeft(find.text('tab')).dy),
    );
    await tester.tap(find.byKey(const Key('log-fuel')));
    expect(_pressed, 1);
  });

  testWidgets('and floats over it on a phone', (tester) async {
    await pumpScreen(
      tester,
      ActionPane(action: _action, body: const Text('tab')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('a tab whose act the top bar offers shows only the tab', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      ActionPane(
        action: PrimaryAction(
          key: const Key('own-add'),
          label: 'Add',
          icon: Icons.add,
          showOnWide: false,
          onPressed: () {},
        ),
        body: const Text('tab'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('own-add')), findsNothing);
    expect(find.text('tab'), findsOneWidget);
  });
}
