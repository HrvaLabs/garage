import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/theme/garage_theme.dart';
import 'package:garage/core/widgets/adaptive.dart';

import '../../support/pump_screen.dart';

/// The desk's theme is chosen by the window, never by platform: a desk gets a
/// mouse's sizes, a phone keeps a thumb's (decision 198).
Future<ThemeData> themeAt(WidgetTester tester, Size surface) async {
  late ThemeData theme;
  await pumpScreen(
    tester,
    Builder(
      builder: (context) {
        theme = Theme.of(context);
        return const SizedBox();
      },
    ),
    surface: surface,
  );
  await tester.pumpAndSettle();
  return theme;
}

void main() {
  testWidgets('a desk gets compact controls and a 14-pixel body', (
    tester,
  ) async {
    final theme = await themeAt(tester, desktopSurface);

    expect(theme.visualDensity, VisualDensity.compact);
    expect(theme.textTheme.bodyLarge!.fontSize, 14);
    expect(theme.splashFactory, NoSplash.splashFactory);
    expect(theme.scrollbarTheme.thumbVisibility!.resolve({}), isTrue);
  });

  testWidgets('a phone keeps its touch targets and its ripple', (tester) async {
    final theme = await themeAt(tester, const Size(400, 900));

    expect(theme.visualDensity, isNot(VisualDensity.compact));
    expect(theme.textTheme.bodyLarge!.fontSize, 16);
    expect(theme.splashFactory, isNot(NoSplash.splashFactory));
  });

  testWidgets('a button on a desk is 40 pixels tall, not 48', (tester) async {
    await pumpDesktop(
      tester,
      Center(
        child: SizedBox(
          width: 200,
          child: FilledButton(onPressed: () {}, child: const Text('Save')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(FilledButton)).height, 40);
  });

  testWidgets('and so is a top-bar button', (tester) async {
    await pumpDesktop(
      tester,
      Center(
        child: FilledButton(
          style: GarageTheme.toolbarButton,
          onPressed: () {},
          child: const Text('Add'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(FilledButton)).height, 40);
  });

  // A card on a monitor is a phone's way to separate rows; a desk gets rows
  // with a rule between them, until the lists become tables.
  testWidgets('a card on a desk is a flat row with a rule under it', (
    tester,
  ) async {
    final theme = await themeAt(tester, desktopSurface);

    expect(theme.cardTheme.color, Colors.transparent);
    expect(theme.cardTheme.margin, EdgeInsets.zero);
    expect(theme.cardTheme.shape, isA<Border>());
  });

  testWidgets('a dialog opened on a desk is compact too', (tester) async {
    late ThemeData dialogTheme;
    await pumpDesktop(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showAdaptiveEntrySheet<void>(context, (context) {
            dialogTheme = Theme.of(context);
            return const SizedBox(height: 10);
          }),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(dialogTheme.visualDensity, VisualDensity.compact);
  });
}
