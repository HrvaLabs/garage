import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/adaptive.dart';
import 'package:garage/core/widgets/anchored_popover.dart';
import 'package:garage/core/widgets/confirm_delete.dart';
import 'package:garage/core/widgets/date_pickers.dart';
import 'package:garage/core/widgets/desktop_shortcuts.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/garage_sidebar.dart';
import 'package:garage/core/widgets/page_scaffold.dart';
import 'package:garage/core/widgets/pointer_anchor.dart';
import 'package:garage/features/vehicles/providers/vehicle_providers.dart';

import '../../support/browser.dart';
import '../../support/pump_screen.dart';
import '../../support/selection.dart';

final _search = GlobalKey();

/// A page with a search of its own, as Vehicles and the timeline have, and a
/// line of text under it.
Widget _page() => GaragePageScaffold(
  title: 'Vehicles',
  body: Column(
    children: [
      SearchShortcutTarget(
        builder: (context, focusNode) =>
            TextField(key: _search, focusNode: focusNode),
      ),
      const Text('Three cars in the garage'),
    ],
  ),
);

/// The search field's own focus, found on the page on top or under it.
FocusNode _searchFocus(WidgetTester tester) => tester
    .widget<TextField>(find.byKey(_search, skipOffstage: false))
    .focusNode!;

Rect _card(WidgetTester tester) =>
    tester.getRect(find.byKey(const Key('anchored-popover')));

Future<void> pressSlash(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.slash, character: '/');
  await tester.pumpAndSettle();
}

Future<void> pressN(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.keyN, character: 'n');
  await tester.pumpAndSettle();
}

Future<void> pressQuestion(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.slash, character: '?');
  await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.pumpAndSettle();
}

void main() {
  setUp(PointerAnchor.reset);

  testWidgets('/ puts the cursor in the page\'s search', (tester) async {
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();

    await pressSlash(tester);

    expect(_searchFocus(tester).hasPrimaryFocus, isTrue);
    expect(pageSearchFocus, same(_searchFocus(tester)));
  });

  testWidgets('/ reaches only the page on top, not a search under it', (
    tester,
  ) async {
    // Vehicles stays built under a car's page, its search with it, covered.
    // The cursor sent there would type into a field nobody can see.
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(
          MaterialPageRoute<void>(
            builder: (context) =>
                const GaragePageScaffold(title: 'Octavia', body: Text('A car')),
          ),
        );
    await tester.pumpAndSettle();
    expect(find.text('A car'), findsOneWidget);

    await pressSlash(tester);

    expect(_searchFocus(tester).hasFocus, isFalse);
    expect(pageSearchFocus, isNull);
  });

  testWidgets('n opens the quick-add from the top bar\'s Add', (tester) async {
    await pumpDesktop(
      tester,
      _page(),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();
    // A press somewhere else first: the key does not hang it there.
    await tester.tapAt(const Offset(700, 500), kind: PointerDeviceKind.mouse);
    await tester.pump();

    await pressN(tester);

    expect(find.text('Fill-up'), findsOneWidget);
    // Below Add, as Add's own menu: Add ends the bar, so the card ends where
    // Add does.
    final add = tester.getRect(find.byKey(const Key('top-bar-quick-add')));
    expect(_card(tester).top, greaterThanOrEqualTo(add.bottom - 1));
    expect(_card(tester).top, closeTo(add.bottom, 1));
    expect(_card(tester).right, closeTo(add.right, 1));
  });

  testWidgets('n on a page with no Add opens over the page, not in a '
      'corner', (tester) async {
    // A tab without a title has no top bar, so no Add: what has the keys is
    // the page itself, as tall as the window, and hung from its corner the
    // card would sit in the window's bottom left, over the sidebar.
    await pumpDesktop(
      tester,
      const GarageTabScaffold(
        current: GarageTab.timeline,
        body: Text('Oil change'),
      ),
      initialLocation: '/timeline',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('top-bar-quick-add')), findsNothing);

    await pressN(tester);

    expect(find.text('Fill-up'), findsOneWidget);
    final pane = tester.getRect(find.byType(PopoverPane));
    final sidebar = tester.getRect(find.byType(GarageSidebar));
    expect(_card(tester).center.dx, closeTo(pane.center.dx, 1));
    expect(_card(tester).center.dy, closeTo(pane.center.dy, 1));
    expect(_card(tester).left, greaterThan(sidebar.right));
    expect(_card(tester).bottom, lessThan(900 - 100));
  });

  testWidgets('n passes on when the cars could not be read', (tester) async {
    // Add hides itself then, and the key does what Add would: nothing,
    // rather than an error from a keypress.
    await pumpDesktop(
      tester,
      _page(),
      initialLocation: '/stats',
      overrides: [
        vehiclesProvider.overrideWith(
          (ref) async => throw Exception('no signal'),
        ),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('top-bar-quick-add')), findsNothing);

    await pressN(tester);

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('anchored-popover')), findsNothing);
  });

  testWidgets('n with Caps Lock on opens the quick-add too', (tester) async {
    await pumpDesktop(
      tester,
      _page(),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyN, character: 'N');
    await tester.pumpAndSettle();

    expect(find.text('Fill-up'), findsOneWidget);
  });

  testWidgets('a key held with Ctrl or ⌘ is the system\'s, not one of these', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      _page(),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    for (final modifier in [
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.meta,
    ]) {
      await tester.sendKeyDownEvent(modifier);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyN, character: 'n');
      await tester.sendKeyEvent(LogicalKeyboardKey.slash, character: '/');
      await tester.sendKeyUpEvent(modifier);
      await tester.pumpAndSettle();
    }

    expect(find.text('Fill-up'), findsNothing);
    expect(_searchFocus(tester).hasFocus, isFalse);
  });

  testWidgets('? lists the shortcuts, and Escape puts the list away', (
    tester,
  ) async {
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();

    await pressQuestion(tester);
    expect(find.text('Keyboard shortcuts'), findsOneWidget);
    expect(find.text('Search this page'), findsOneWidget);
    expect(find.text('Add a fill-up, a service or a cost'), findsOneWidget);
    expect(find.text('Show this list'), findsOneWidget);
    expect(find.text('Close a dialog or a menu'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Keyboard shortcuts'), findsNothing);

    // The page has the keys again once the list has gone.
    await pressQuestion(tester);
    expect(find.text('Keyboard shortcuts'), findsOneWidget);
  });

  testWidgets('the list reads in Croatian at a desk', (tester) async {
    await pumpDesktop(
      tester,
      _page(),
      initialLocation: '/stats',
      locale: const Locale('hr'),
      textScale: 1.5,
      surface: const Size(900, 600),
    );
    await tester.pumpAndSettle();

    await pressQuestion(tester);

    expect(find.text('Tipkovnički prečaci'), findsOneWidget);
    expect(find.text('Dodaj točenje, servis ili trošak'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('a key typed into a field stays in the field', () {
    testWidgets('on the page', (tester) async {
      await pumpDesktop(
        tester,
        _page(),
        initialLocation: '/stats',
        vehicles: [testVehicle('v1')],
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_search));
      await tester.pump();

      await pressQuestion(tester);
      await pressN(tester);
      await pressSlash(tester);

      expect(find.text('Keyboard shortcuts'), findsNothing);
      expect(find.text('Fill-up'), findsNothing);
      expect(_searchFocus(tester).hasPrimaryFocus, isTrue);
    });

    for (final (where, open) in <(String, Future<void> Function(BuildContext))>[
      (
        'in an entry sheet',
        (context) => showAdaptiveEntrySheet<void>(
          context,
          (context) => const Padding(
            padding: EdgeInsets.all(24),
            child: TextField(key: Key('note')),
          ),
        ),
      ),
      (
        'in a popover',
        (context) => showAnchoredPopover<void>(
          context,
          builder: (context) => const Padding(
            padding: EdgeInsets.all(24),
            child: TextField(key: Key('note')),
          ),
        ),
      ),
    ]) {
      testWidgets(where, (tester) async {
        await pumpDesktop(
          tester,
          GaragePageScaffold(
            title: 'Fuel',
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => open(context),
                child: const Text('Open'),
              ),
            ),
          ),
          initialLocation: '/stats',
          vehicles: [testVehicle('v1')],
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('note')));
        await tester.pump();

        await pressQuestion(tester);
        await pressN(tester);

        expect(find.text('Keyboard shortcuts'), findsNothing);
        expect(find.text('Fill-up'), findsNothing);
        final field = tester.widget<EditableText>(
          find.descendant(
            of: find.byKey(const Key('note')),
            matching: find.byType(EditableText),
          ),
        );
        expect(field.focusNode.hasPrimaryFocus, isTrue);
      });
    }
  });

  testWidgets('the keys still reach the page after a click away from a '
      'field', (tester) async {
    // A click outside a field takes the cursor out of it, and the focus
    // falls back to the page as a whole.
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(_search), kind: PointerDeviceKind.mouse);
    await tester.pump();
    expect(_searchFocus(tester).hasFocus, isTrue);

    await tester.tap(
      find.text('Three cars in the garage'),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(_searchFocus(tester).hasFocus, isFalse);

    await pressQuestion(tester);
    expect(find.text('Keyboard shortcuts'), findsOneWidget);
  });

  group('with the page\'s text clicked, in a browser', () {
    /// A click on the page's text, which gives it the keys, as a click in a
    /// browser does.
    Future<FakeBrowser> clickTheText(WidgetTester tester) async {
      final browser = asTheWeb(tester);
      await pumpDesktop(
        tester,
        _page(),
        initialLocation: '/stats',
        vehicles: [testVehicle('v1')],
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Three cars in the garage'),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(FocusManager.instance.primaryFocus?.debugLabel, 'SelectablePage');
      return browser;
    }

    testWidgets('/ still finds the search', (tester) async {
      await clickTheText(tester);

      await pressSlash(tester);

      expect(_searchFocus(tester).hasPrimaryFocus, isTrue);
    });

    testWidgets('n still opens the quick-add from Add', (tester) async {
      await clickTheText(tester);

      await pressN(tester);

      final add = tester.getRect(find.byKey(const Key('top-bar-quick-add')));
      expect(find.text('Fill-up'), findsOneWidget);
      expect(_card(tester).top, closeTo(add.bottom, 1));
      expect(_card(tester).right, closeTo(add.right, 1));
    });

    testWidgets('? still lists them', (tester) async {
      await clickTheText(tester);

      await pressQuestion(tester);

      expect(find.text('Keyboard shortcuts'), findsOneWidget);
    });

    testWidgets('and select all and copy are still the selection\'s', (
      tester,
    ) async {
      final browser = await clickTheText(tester);

      await selectAllWithKeyboard(tester);
      await copyWithKeyboard(tester);

      expect(browser.copied, contains('Three cars in the garage'));
      expect(find.text('Keyboard shortcuts'), findsNothing);
      expect(find.text('Fill-up'), findsNothing);
    });
  });

  group('Tab, with the keys on the page', () {
    late FocusNode first;
    late FocusNode last;

    setUp(() {
      first = FocusNode(debugLabel: 'first');
      last = FocusNode(debugLabel: 'last');
    });
    tearDown(() {
      first.dispose();
      last.dispose();
    });

    Widget controls() => Column(
      children: [
        TextButton(
          focusNode: first,
          onPressed: () {},
          child: const Text('first'),
        ),
        TextButton(
          focusNode: last,
          onPressed: () {},
          child: const Text('last'),
        ),
      ],
    );

    Future<bool> tab(WidgetTester tester, {bool back = false}) async {
      if (back) {
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      }
      final handled = await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      if (back) {
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      }
      await tester.pumpAndSettle();
      return handled;
    }

    bool onTheAction() =>
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<SnackBarAction>() !=
        null;

    bool onThePage() =>
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<DesktopShortcuts>() !=
        null;

    testWidgets('reaches a snackbar\'s action from the page and comes back, '
        'both ways', (tester) async {
      // A notice sits in the page's Scaffold, beside its body: a scope of
      // its own round the body kept Tab inside it, and from the action Tab
      // went nowhere.
      await pumpDesktop(
        tester,
        GaragePageScaffold(title: 'Fuel', body: controls()),
        initialLocation: '/stats',
      );
      await tester.pumpAndSettle();
      ScaffoldMessenger.of(tester.element(find.text('first'))).showSnackBar(
        SnackBar(
          duration: const Duration(days: 1),
          content: const Text('Saved'),
          action: SnackBarAction(label: 'Undo', onPressed: () {}),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      last.requestFocus();
      await tester.pump();

      await tab(tester);
      expect(onTheAction(), isTrue, reason: 'Tab from the page\'s last');
      await tab(tester);
      expect(onThePage(), isTrue, reason: 'and Tab on into the page');
      await tab(tester, back: true);
      expect(onTheAction(), isTrue, reason: 'Shift+Tab from its first');
      await tab(tester, back: true);
      expect(last.hasPrimaryFocus, isTrue, reason: 'and back to its last');
    });

    testWidgets('leaves the view at a route\'s edge that leaves it', (
      tester,
    ) async {
      // The web's own navigator hands Tab at a page's end to the browser.
      // The keys add no focus of their own to keep it.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [vehiclesProvider.overrideWith((ref) async => const [])],
          child: MaterialApp(
            home: Navigator(
              routeTraversalEdgeBehavior:
                  TraversalEdgeBehavior.leaveFlutterView,
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (_) =>
                    Scaffold(body: DesktopShortcuts(child: controls())),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      last.requestFocus();
      await tester.pump();

      expect(await tab(tester), isFalse);
    });
  });

  group('a dialog over the page has none of them', () {
    /// A search, and a button that asks a question in a dialog.
    Widget body() => Column(
      children: [
        SearchShortcutTarget(
          builder: (context, focusNode) =>
              TextField(key: _search, focusNode: focusNode),
        ),
        Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                confirmAction(context, body: 'Sure?', confirmLabel: 'Yes'),
            child: const Text('Ask'),
          ),
        ),
      ],
    );

    for (final (name, location, page) in <(String, String, Widget)>[
      (
        'a tab',
        '/timeline',
        GarageTabScaffold(
          current: GarageTab.timeline,
          title: 'Timeline',
          body: body(),
        ),
      ),
      (
        'a pushed page',
        '/stats',
        GaragePageScaffold(title: 'Fuel', body: body()),
      ),
    ]) {
      testWidgets('over $name, with the focus on its button', (tester) async {
        await pumpDesktop(
          tester,
          page,
          initialLocation: location,
          vehicles: [testVehicle('v1')],
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ask'));
        await tester.pumpAndSettle();
        Focus.of(tester.element(find.text('Yes'))).requestFocus();
        await tester.pump();

        await pressN(tester);
        await pressSlash(tester);
        await pressQuestion(tester);

        expect(find.text('Sure?'), findsOneWidget);
        expect(find.text('Fill-up'), findsNothing);
        expect(_searchFocus(tester).hasFocus, isFalse);
        expect(find.text('Keyboard shortcuts'), findsNothing);
      });
    }
  });

  group('a popover over the page has none of them', () {
    testWidgets('n in an open quick-add does not open a second', (
      tester,
    ) async {
      await pumpDesktop(
        tester,
        _page(),
        initialLocation: '/stats',
        vehicles: [testVehicle('v1')],
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('top-bar-quick-add')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('anchored-popover')), findsOneWidget);

      await pressN(tester);

      expect(find.byKey(const Key('anchored-popover')), findsOneWidget);
      expect(find.text('Fill-up'), findsOneWidget);
    });

    testWidgets('? under the date\'s popover opens no list', (tester) async {
      await pumpDesktop(
        tester,
        GaragePageScaffold(
          title: 'Fuel',
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showGarageDatePicker(
                context: context,
                initialDate: DateTime(2026, 10, 19),
                firstDate: DateTime(2000),
                lastDate: DateTime(2030),
              ),
              child: const Text('Date'),
            ),
          ),
        ),
        initialLocation: '/stats',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Date'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('anchored-popover')), findsOneWidget);
      // Off the web the date's field waits for a click, so what holds the
      // key back is the popover over the page, not a field taking it.
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isFalse,
      );

      await pressQuestion(tester);

      expect(find.text('Keyboard shortcuts'), findsNothing);
      expect(find.byKey(const Key('anchored-popover')), findsOneWidget);
    });
  });

  testWidgets('two sets of keys under one route act once on a key', (
    tester,
  ) async {
    // Each is told of the key; the first to act on it takes it. A dialog
    // takes the page off the top at once, which would hide a second `?`, but
    // the quick-add opens only after reading the cars, so `n` would show it.
    await pumpDesktop(
      tester,
      const GaragePageScaffold(
        title: 'Fuel',
        body: DesktopShortcuts(child: Text('a page within the page')),
      ),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();
    expect(find.byType(DesktopShortcuts), findsNWidgets(2));

    await pressN(tester);

    expect(find.byKey(const Key('anchored-popover')), findsOneWidget);
  });

  testWidgets('a phone has none of them', (tester) async {
    await pumpScreen(
      tester,
      _page(),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    await pressQuestion(tester);
    await pressN(tester);
    await pressSlash(tester);

    expect(find.text('Keyboard shortcuts'), findsNothing);
    expect(find.text('Fill-up'), findsNothing);
    expect(_searchFocus(tester).hasFocus, isFalse);
    expect(find.byType(DesktopShortcuts), findsNothing);
  });
}
