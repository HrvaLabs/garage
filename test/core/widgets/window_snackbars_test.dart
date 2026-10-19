import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/theme/garage_tokens.dart';
import 'package:garage/core/widgets/window_snackbars.dart';

/// [beside] sits in the page's bottom left corner, level with the notice.
Future<void> pumpApp(
  WidgetTester tester,
  Size surface, {
  Widget? beside,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = surface;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => WindowSnackBars(child: child!),
      home: Scaffold(
        body: Builder(
          builder: (context) => Stack(
            children: [
              TextButton(
                onPressed: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('toast'))),
                child: const Text('show'),
              ),
              if (beside != null)
                Align(alignment: Alignment.bottomLeft, child: beside),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('show'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

/// The card itself: the SnackBar widget keeps the row, its material takes
/// the width.
Finder material() => find
    .descendant(of: find.byType(SnackBar), matching: find.byType(Material))
    .first;

void main() {
  testWidgets('on a desktop window a notice sits in the bottom right corner', (
    tester,
  ) async {
    // Same messages, same Retry; only where it appears changes. Under the
    // middle of the page it covered the row the message was about.
    await pumpApp(tester, const Size(1400, 900));

    final toast = tester.getRect(material());
    expect(toast.width, WindowSnackBars.toastWidth);
    expect(toast.right, closeTo(1400 - GarageTokens.space6, 1));
    expect(toast.bottom, closeTo(900 - GarageTokens.space6, 1));
  });

  testWidgets('beside the notice the page still takes a click', (tester) async {
    // The margin that puts the notice in the corner is as wide as the rest
    // of the window. Were it to stop a click, the bottom of every page on a
    // desk would be dead for as long as a notice showed.
    var clicks = 0;
    await pumpApp(
      tester,
      const Size(1400, 900),
      beside: TextButton(
        onPressed: () => clicks++,
        child: const Text('beside'),
      ),
    );

    await tester.tap(find.text('beside'));
    expect(clicks, 1);
  });

  testWidgets('on a phone it keeps the width it had', (tester) async {
    await pumpApp(tester, const Size(400, 800));

    final toast = tester.getRect(material());
    expect(toast.width, 400 - 32);
  });
}
