import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// That the page's one floating button is the one its screen used to build
/// for itself: [icon] and [label] when [extended], [icon] alone when not, and
/// no tooltip either way. A primary action reaches a phone unchanged.
void expectFloatingButton(
  WidgetTester tester, {
  required String label,
  required IconData icon,
  Key? key,
  bool extended = true,
}) {
  final button = find.byType(FloatingActionButton);
  expect(button, findsOneWidget);
  final widget = tester.widget<FloatingActionButton>(button);
  expect(widget.key, key);
  expect(widget.isExtended, extended);
  expect(widget.tooltip, isNull);
  expect(
    find.descendant(of: button, matching: find.byIcon(icon)),
    findsOneWidget,
  );
  expect(
    find.descendant(of: button, matching: find.text(label)),
    extended ? findsOneWidget : findsNothing,
  );
}
