import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/context_menu_region.dart';
import 'package:garage/core/widgets/page_scaffold.dart';

import '../../support/browser.dart';
import '../../support/pump_screen.dart';
import '../../support/right_click.dart';

String? done;

/// The selection's own menu: Select all, spelled as Material spells it and
/// as a Mac's does.
final _selectAll = find.textContaining(
  RegExp(r'^select all$', caseSensitive: false),
);
final _copy = find.textContaining(RegExp(r'^copy$', caseSensitive: false));

List<PopupMenuEntry<String>> _items(BuildContext context) => const [
  PopupMenuItem(value: 'edit', child: Text('Edit')),
  PopupMenuItem(value: 'delete', child: Text('Delete')),
];

Widget _region({bool enabled = true, Widget? child}) =>
    ContextMenuRegion<String>(
      enabled: enabled,
      itemBuilder: _items,
      onSelected: (action) => done = action,
      child: child ?? const ListTile(title: Text('Winter tyres')),
    );

Widget _row({bool enabled = true, Widget? child}) => Scaffold(
  body: _region(enabled: enabled, child: child),
);

/// A row with a menu on a page that is otherwise text, as a desk draws it.
Widget _page() => GaragePageScaffold(
  title: 'Tyres',
  body: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [const Text('Two sets on record'), _region()],
  ),
);

/// Counts its builds' States: the one alive is the last made.
class _Kept extends StatefulWidget {
  const _Kept();

  @override
  State<_Kept> createState() => _KeptState();
}

class _KeptState extends State<_Kept> {
  @override
  Widget build(BuildContext context) =>
      const ListTile(title: Text('Winter tyres'));
}

void main() {
  setUp(() => done = null);

  testWidgets('a right click on a row offers what its ⋮ does', (tester) async {
    await pumpDesktop(tester, _row());
    await tester.pumpAndSettle();

    await rightClick(tester, find.text('Winter tyres'));
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(done, 'delete');
  });

  testWidgets('it opens where the pointer is', (tester) async {
    await pumpDesktop(tester, _row());
    await tester.pumpAndSettle();
    final at = tester.getCenter(find.text('Winter tyres'));

    await rightClick(tester, find.text('Winter tyres'));

    final menu = tester.getRect(
      find
          .ancestor(of: find.text('Edit'), matching: find.byType(Material))
          .first,
    );
    expect((menu.left - at.dx).abs(), lessThan(1));
    expect((menu.top - at.dy).abs(), lessThan(1));
  });

  testWidgets('closed with nothing chosen, it does nothing', (tester) async {
    await pumpDesktop(tester, _row());
    await tester.pumpAndSettle();

    await rightClick(tester, find.text('Winter tyres'));
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Delete'), findsNothing);
    expect(done, isNull);
  });

  testWidgets('a menu whose items act themselves acts on a right click too, '
      'once', (tester) async {
    var retired = 0;
    await pumpDesktop(
      tester,
      Scaffold(
        body: ContextMenuRegion<void>(
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              onTap: () => retired += 1,
              child: const Text('Retire'),
            ),
          ],
          onSelected: (_) {},
          child: const ListTile(title: Text('Winter tyres')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await rightClick(tester, find.text('Winter tyres'));
    await tester.tap(find.text('Retire'));
    await tester.pumpAndSettle();

    expect(retired, 1);
  });

  testWidgets('a row whose ⋮ is not shown has no right click either', (
    tester,
  ) async {
    await pumpDesktop(tester, _row(enabled: false));
    await tester.pumpAndSettle();

    await rightClick(tester, find.text('Winter tyres'));

    expect(find.text('Delete'), findsNothing);
  });

  testWidgets('a phone has no right click', (tester) async {
    await pumpScreen(tester, _row());
    await tester.pumpAndSettle();

    await rightClick(tester, find.text('Winter tyres'));

    expect(find.text('Delete'), findsNothing);
  });

  // A wrapper that came and went with the window's width would build the row
  // again from nothing whenever a window was resized across the line.
  testWidgets('a window resized across the line keeps the row under it', (
    tester,
  ) async {
    await pumpDesktop(tester, _row(child: const _Kept()));
    await tester.pumpAndSettle();
    final before = tester.state<_KeptState>(find.byType(_Kept));

    tester.view.physicalSize = const Size(400, 900);
    await tester.pumpAndSettle();
    expect(tester.state<_KeptState>(find.byType(_Kept)), same(before));

    tester.view.physicalSize = desktopSurface;
    await tester.pumpAndSettle();
    expect(tester.state<_KeptState>(find.byType(_Kept)), same(before));
  });

  // The page's text is a selection there, whose own right-click shows its
  // Copy and Select all. A row's right-click is the row's alone: the two
  // menus at once were a click held past the moment a tap becomes a press.
  group('on a desk in a browser, where the page is text', () {
    for (final (name, click) in [
      ('a quick right click', rightClick),
      ('a right click held down', holdRightClick),
    ]) {
      testWidgets('$name on a row opens its menu and nothing else', (
        tester,
      ) async {
        asTheWeb(tester);
        await pumpDesktop(tester, _page(), initialLocation: '/stats');
        await tester.pumpAndSettle();
        expect(
          find.ancestor(
            of: find.text('Winter tyres'),
            matching: find.byType(SelectableRegion),
          ),
          findsOneWidget,
          reason: 'the row is on the page\'s text',
        );

        await click(tester, find.text('Winter tyres'));

        expect(find.text('Delete'), findsOneWidget);
        expect(_selectAll, findsNothing);
        expect(_copy, findsNothing);
      }, variant: TargetPlatformVariant.desktop());
    }

    // As a desk's menu does: held, it is already open, not when the press
    // has been held long enough to be told from a tap, nor on release.
    testWidgets('the menu opens as the button goes down', (tester) async {
      asTheWeb(tester);
      await pumpDesktop(tester, _page(), initialLocation: '/stats');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Winter tyres')),
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryButton,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(find.text('Delete'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Delete'), findsOneWidget, reason: 'and stays open');
      expect(_selectAll, findsNothing);
    }, variant: TargetPlatformVariant.desktop());

    testWidgets('a right click held on the text beside it is the text\'s', (
      tester,
    ) async {
      asTheWeb(tester);
      await pumpDesktop(tester, _page(), initialLocation: '/stats');
      await tester.pumpAndSettle();

      await holdRightClick(tester, find.text('Two sets on record'));

      expect(_selectAll, findsOneWidget);
      expect(find.text('Delete'), findsNothing);
    }, variant: TargetPlatformVariant.desktop());
  });

  // The page's keys act only while its route is on top. The menu is a route
  // over the page, as a ⋮'s is, so `n` does not open the quick-add under it.
  testWidgets('the page\'s keys stay quiet under a row\'s menu', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      _page(),
      initialLocation: '/stats',
      vehicles: [testVehicle('v1')],
    );
    await tester.pumpAndSettle();

    await rightClick(tester, find.text('Winter tyres'));
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN, character: 'n');
    await tester.pumpAndSettle();
    expect(find.text('Fill-up'), findsNothing);
    expect(find.text('Delete'), findsOneWidget, reason: 'the menu is open');

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN, character: 'n');
    await tester.pumpAndSettle();
    expect(find.text('Fill-up'), findsOneWidget, reason: 'and without it');
  });

  testWidgets('a middle click opens no menu', (tester) async {
    await pumpDesktop(tester, _row());
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('Winter tyres'),
      buttons: kMiddleMouseButton,
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();

    expect(find.text('Delete'), findsNothing);
  });
}
