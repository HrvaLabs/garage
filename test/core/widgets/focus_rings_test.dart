import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/theme/garage_theme.dart';
import 'package:garage/core/theme/garage_tokens.dart';
import 'package:garage/core/widgets/focus_rings.dart';
import 'package:garage/core/widgets/page_scaffold.dart';

import '../../support/pump_screen.dart';

late FocusNode _before;
late FocusNode _save;

/// A page with a button to start from and the button Tab reaches next.
Widget _page() => GaragePageScaffold(
  title: 'Fuel',
  body: Column(
    children: [
      TextButton(
        focusNode: _before,
        onPressed: () {},
        child: const Text('Before'),
      ),
      FilledButton(
        focusNode: _save,
        style: GarageTheme.inlineButton,
        onPressed: () {},
        child: const Text('Save'),
      ),
    ],
  ),
);

final _button = find.widgetWithText(FilledButton, 'Save');

/// The edge [button] is drawn with, Save unless another is named.
BorderSide _side(WidgetTester tester, [Finder? button]) {
  final material = tester.widget<Material>(
    find.descendant(of: button ?? _button, matching: find.byType(Material)),
  );
  return (material.shape! as OutlinedBorder).side;
}

/// Tab, from the button before the one under test.
Future<void> _tabToSave(WidgetTester tester) async {
  _before.requestFocus();
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();
  expect(_save.hasPrimaryFocus, isTrue);
}

void main() {
  setUp(() {
    _before = FocusNode(debugLabel: 'before');
    _save = FocusNode(debugLabel: 'save');
  });
  tearDown(() {
    _before.dispose();
    _save.dispose();
  });

  testWidgets('a button reached with Tab on a desk is drawn with a ring', (
    tester,
  ) async {
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();
    expect(_side(tester), BorderSide.none);

    await _tabToSave(tester);

    final ring = _side(tester);
    expect(ring.color, GarageTokens.light.accent);
    expect(ring.width, 2);
    // Outside the button and clear of it, so a filled button in the same
    // amber still shows it: the stroke's inner edge is beyond the button's.
    expect(ring.strokeInset, lessThan(0));
    expect(
      tester.renderObject(_button),
      paints..drrect(color: GarageTokens.light.accent),
    );
    // Only the button with the focus.
    expect(
      _side(tester, find.widgetWithText(TextButton, 'Before')),
      BorderSide.none,
    );
  });

  testWidgets('a click puts the ring away, though the button keeps the '
      'focus', (tester) async {
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();
    await _tabToSave(tester);

    await tester.tap(_button, kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();

    expect(_save.hasPrimaryFocus, isTrue);
    expect(_side(tester), BorderSide.none);
    expect(
      tester.renderObject(_button),
      isNot(paints..drrect(color: GarageTokens.light.accent)),
    );

    // And Tab brings it back, on whatever it reaches.
    _before.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(_side(tester).color, GarageTokens.light.accent);
  });

  testWidgets('a click anywhere puts it away', (tester) async {
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();
    await _tabToSave(tester);

    await tester.tapAt(const Offset(1000, 700), kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();

    expect(_side(tester), BorderSide.none);
  });

  testWidgets('an arrow that moves the focus draws it too', (tester) async {
    // On a desk the arrows move the focus as Tab does.
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();
    _before.requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    expect(_save.hasPrimaryFocus, isTrue);
    expect(_side(tester).color, GarageTokens.light.accent);
  });

  testWidgets('each of the four arrows does, after a click', (tester) async {
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();

    for (final arrow in [
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
    ]) {
      await tester.tapAt(
        const Offset(1000, 700),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pump();
      expect(FocusRings.drawn.value, isFalse);

      await tester.sendKeyEvent(arrow);
      await tester.pump();

      expect(FocusRings.drawn.value, isTrue, reason: '$arrow');
    }
  });

  testWidgets('a phone draws no ring', (tester) async {
    await pumpScreen(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();

    await _tabToSave(tester);

    expect(_side(tester), BorderSide.none);
  });

  testWidgets('a frame starts with none drawn', (tester) async {
    // A Tab pressed under one frame, in one test, is not the next one's.
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();
    await _tabToSave(tester);
    expect(FocusRings.drawn.value, isTrue);

    await tester.pumpWidget(const SizedBox());
    await pumpDesktop(tester, _page(), initialLocation: '/stats');
    await tester.pumpAndSettle();

    expect(FocusRings.drawn.value, isFalse);
  });
}
