import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drags a mouse across [part] of the text [text] finds, from its last
/// character back to its first: how a reader on a desk selects a figure, and
/// the way a row is swiped to delete it, so a row that still took a mouse's
/// swipe would be pulled away instead.
///
/// Aimed at the characters themselves. A `Text` is often wider than what it
/// says, and a drag that starts past its last character selects nothing.
Future<void> mouseDragAcross(
  WidgetTester tester,
  Finder text,
  String part,
) async {
  final paragraph = tester.renderObject<RenderParagraph>(
    find.descendant(of: text, matching: find.byType(RichText)),
  );
  final whole = paragraph.text.toPlainText();
  final first = whole.indexOf(part);
  expect(first, isNot(-1), reason: '"$part" is not in "$whole"');
  Offset at(int offset) => paragraph.localToGlobal(
    paragraph.getOffsetForCaret(TextPosition(offset: offset), Rect.zero) +
        Offset(0, paragraph.size.height / 2),
  );
  final from = at(first + part.length) - const Offset(1, 0);
  final to = at(first);

  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: from);
  await mouse.down(from);
  await tester.pump(const Duration(milliseconds: 16));
  const steps = 8;
  for (var step = 0; step < steps; step++) {
    await mouse.moveBy((to - from) / steps.toDouble());
    await tester.pump(const Duration(milliseconds: 16));
  }
  await mouse.up();
  await mouse.removePointer();
  await tester.pumpAndSettle();
}

/// The keyboard's Select all, Ctrl+A where a test runs.
Future<void> selectAllWithKeyboard(WidgetTester tester) =>
    _withControl(tester, LogicalKeyboardKey.keyA);

/// The keyboard's Copy, Ctrl+C where a test runs. What it copies lands in
/// `FakeBrowser.copied`.
Future<void> copyWithKeyboard(WidgetTester tester) =>
    _withControl(tester, LogicalKeyboardKey.keyC);

Future<void> _withControl(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
  await tester.sendKeyEvent(key);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.control);
  await tester.pump();
}
