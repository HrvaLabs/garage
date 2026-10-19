import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/theme/garage_tokens.dart';
import 'package:garage/core/widgets/page_header.dart';
import 'package:garage/l10n/app_localizations.dart';

Future<void> pumpHeader(
  WidgetTester tester,
  Size size, {
  List<Widget> actions = const [],
  VoidCallback? onBack,
  List<Crumb> crumbs = const [],
  List<Widget> trailing = const [],
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PageHeader(
          title: 'Fuel',
          actions: actions,
          onBack: onBack,
          crumbs: crumbs,
          trailing: trailing,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the title is set as a page heading, not app-bar sized', (
    tester,
  ) async {
    await pumpHeader(tester, const Size(1500, 1000));

    final style = tester.widget<Text>(find.text('Fuel')).style;
    final expected = Theme.of(
      tester.element(find.text('Fuel')),
    ).textTheme.headlineSmall;

    expect(
      style?.fontSize,
      expected?.fontSize,
      reason:
          'a desktop page names itself in its content, at content scale, '
          'rather than in a phone app bar',
    );
  });

  testWidgets('actions stay available beside the title', (tester) async {
    await pumpHeader(
      tester,
      const Size(1500, 1000),
      actions: [
        IconButton(
          key: const Key('action'),
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
      ],
    );

    expect(find.byKey(const Key('action')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const Key('action'))).dx,
      greaterThan(tester.getTopLeft(find.text('Fuel')).dx),
    );
  });

  testWidgets('a screen you can go back from offers a way back', (
    tester,
  ) async {
    var popped = false;
    await pumpHeader(
      tester,
      const Size(1500, 1000),
      onBack: () => popped = true,
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(popped, isTrue);
  });

  testWidgets('a top-level screen shows no back affordance', (tester) async {
    await pumpHeader(tester, const Size(1500, 1000));

    expect(
      find.byTooltip('Back'),
      findsNothing,
      reason:
          'the sidebar is the navigation on desktop; a back arrow on a '
          'top-level page is phone chrome with nowhere to go',
    );
  });

  testWidgets('where the page sits is said above its title, in links', (
    tester,
  ) async {
    await pumpHeader(
      tester,
      const Size(1500, 1000),
      crumbs: const [
        Crumb('Vehicles', '/vehicles'),
        Crumb('Golf', '/vehicles/v1'),
      ],
    );

    expect(
      tester.getTopLeft(find.text('Golf')).dy,
      lessThan(tester.getTopLeft(find.text('Fuel')).dy),
    );
    expect(
      tester.getSemantics(find.byKey(const Key('crumb-/vehicles'))),
      isSemantics(label: 'Vehicles', isLink: true, hasTapAction: true),
    );
  });

  group('a crumb', () {
    const crumbs = [
      Crumb('Vehicles', '/vehicles'),
      Crumb('Golf', '/vehicles/v1'),
    ];

    // Bare, a crumb's target was its small text, 16 pixels high, and on a
    // tablet held sideways a crumb is touched rather than clicked.
    testWidgets('is a target bigger than its text', (tester) async {
      await pumpHeader(tester, const Size(1500, 1000), crumbs: crumbs);

      for (final crumb in crumbs) {
        final target = tester.getSize(find.byKey(Key('crumb-${crumb.route}')));
        final text = tester.getSize(find.text(crumb.label));
        expect(
          target.height,
          greaterThanOrEqualTo(text.height + 2 * GarageTokens.space1),
          reason: crumb.label,
        );
        expect(
          target.width,
          greaterThanOrEqualTo(text.width + 2 * GarageTokens.space1),
          reason: crumb.label,
        );
      }
    });

    testWidgets('answers out to the edges of that target', (tester) async {
      await pumpHeader(tester, const Size(1500, 1000), crumbs: crumbs);

      final first = find.byKey(const Key('crumb-/vehicles'));
      for (final at in const [Alignment.centerLeft, Alignment.topCenter]) {
        expect(first.hitTestable(at: at), findsOneWidget, reason: '$at');
      }
    });

    testWidgets('leaves its text, the title and the arrow where they were', (
      tester,
    ) async {
      await pumpHeader(tester, const Size(1500, 1000), crumbs: crumbs);

      expect(
        tester.getTopLeft(find.text('Vehicles')),
        const Offset(GarageTokens.space4, GarageTokens.space4),
      );
      expect(tester.getTopLeft(find.text('Fuel')).dx, GarageTokens.space4);

      await pumpHeader(
        tester,
        const Size(1500, 1000),
        crumbs: crumbs,
        onBack: () {},
      );

      final arrow = find.byType(IconButton);
      expect(tester.getTopLeft(arrow).dx, GarageTokens.space4);
      final column = tester.getTopRight(arrow).dx + GarageTokens.space2;
      expect(tester.getTopLeft(find.text('Fuel')).dx, column);
      expect(tester.getTopLeft(find.text('Vehicles')).dx, column);
    });
  });

  testWidgets('what every page offers comes after the page\'s own actions', (
    tester,
  ) async {
    await pumpHeader(
      tester,
      const Size(1500, 1000),
      actions: [
        IconButton(
          key: const Key('action'),
          onPressed: () {},
          icon: const Icon(Icons.edit),
        ),
      ],
      trailing: [
        IconButton(
          key: const Key('trailing'),
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
      ],
    );

    expect(
      tester.getTopLeft(find.byKey(const Key('trailing'))).dx,
      greaterThan(tester.getTopRight(find.byKey(const Key('action'))).dx),
    );
  });

  testWidgets('what every page offers stays itself as a page\'s own comes and '
      'goes', (tester) async {
    // A page's own act joins the bar once its list has loaded. Paired with it
    // by position, the quick-add was built again from scratch, and a choice
    // made in its dialog meanwhile went nowhere.
    final own = FilledButton(
      key: const Key('own'),
      onPressed: () {},
      child: const Text('Own'),
    );
    final every = OutlinedButton(
      key: const Key('every'),
      onPressed: () {},
      child: const Text('Add'),
    );

    await pumpHeader(tester, const Size(1500, 1000), trailing: [every]);
    final before = tester.element(find.byKey(const Key('every')));

    await pumpHeader(tester, const Size(1500, 1000), trailing: [own, every]);
    expect(find.byKey(const Key('own')), findsOneWidget);
    expect(tester.element(find.byKey(const Key('every'))), same(before));

    await pumpHeader(tester, const Size(1500, 1000), trailing: [every]);
    expect(find.byKey(const Key('own')), findsNothing);
    expect(tester.element(find.byKey(const Key('every'))), same(before));
  });

  testWidgets('and a keyed one, whatever kind of widget joins it', (
    tester,
  ) async {
    // Two of a kind side by side are told apart by their keys alone.
    final own = OutlinedButton(
      key: const Key('own'),
      onPressed: () {},
      child: const Text('Own'),
    );
    final every = OutlinedButton(
      key: const Key('every'),
      onPressed: () {},
      child: const Text('Add'),
    );

    await pumpHeader(tester, const Size(1500, 1000), trailing: [every]);
    final before = tester.element(find.byKey(const Key('every')));

    await pumpHeader(tester, const Size(1500, 1000), trailing: [own, every]);
    expect(tester.element(find.byKey(const Key('every'))), same(before));

    await pumpHeader(tester, const Size(1500, 1000), trailing: [every]);
    expect(tester.element(find.byKey(const Key('every'))), same(before));
  });

  group('the crumbs a page is given from its address', () {
    late AppLocalizations l10n;
    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    test('a section itself has none', () {
      expect(sectionCrumbs(l10n, '/stats'), isEmpty);
      expect(sectionCrumbs(l10n, '/vehicles'), isEmpty);
    });

    test('a page one below a section names the section', () {
      expect(sectionCrumbs(l10n, '/household/merge').map((c) => c.route), [
        '/household',
      ]);
      expect(sectionCrumbs(l10n, '/vehicles/v1').map((c) => c.label), [
        'Vehicles',
      ]);
      expect(sectionCrumbs(l10n, '/api/webhooks/w1').map((c) => c.route), [
        '/api',
      ]);
    });

    test('a car\'s own page names Vehicles and the car', () {
      final crumbs = sectionCrumbs(l10n, '/vehicles/v1/fuel', carName: 'Golf');
      expect(crumbs.map((c) => c.label), ['Vehicles', 'Golf']);
      expect(crumbs.map((c) => c.route), ['/vehicles', '/vehicles/v1']);
    });

    test('and names the car only once its name is known', () {
      // Not "Vehicles › Vehicles" while the car loads, or for a car the
      // startup fetch does not know.
      final crumbs = sectionCrumbs(l10n, '/vehicles/v1/fuel');
      expect(crumbs.map((c) => c.label), ['Vehicles']);
      expect(crumbs.map((c) => c.route), ['/vehicles']);
    });

    test('a new car is not a car', () {
      expect(sectionCrumbs(l10n, '/vehicles/new').map((c) => c.label), [
        'Vehicles',
      ]);
    });

    test('a driver\'s cars are Cars, as in the sidebar', () {
      expect(
        sectionCrumbs(
          l10n,
          '/vehicles/v1/fuel',
          carName: 'Golf',
          driver: true,
        ).map((c) => c.label),
        ['Cars', 'Golf'],
      );
      expect(
        sectionCrumbs(
          l10n,
          '/household/merge',
          driver: true,
        ).map((c) => c.label),
        ['Garage'],
      );
    });
  });
}
