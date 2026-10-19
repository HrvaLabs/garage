import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

/// A right-click with a mouse on [finder], as a desk's is, and whatever menu
/// it opens settled on screen.
Future<void> rightClick(WidgetTester tester, Finder finder) async {
  await tester.tap(
    finder,
    buttons: kSecondaryButton,
    kind: PointerDeviceKind.mouse,
  );
  await tester.pumpAndSettle();
}

/// A right-click held past the moment a tap becomes a press, as a hand that
/// is not in a hurry makes one, then let go.
Future<void> holdRightClick(WidgetTester tester, Finder finder) async {
  final gesture = await tester.startGesture(
    tester.getCenter(finder),
    kind: PointerDeviceKind.mouse,
    buttons: kSecondaryButton,
  );
  await tester.pump(kPressTimeout + const Duration(milliseconds: 50));
  await gesture.up();
  await tester.pumpAndSettle();
}
