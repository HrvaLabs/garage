import 'package:flutter/material.dart';

import '../theme/garage_theme.dart';
import '../web/update_notice.dart';
import 'adaptive.dart';
import 'window_snackbars.dart';

/// What the app puts between `MaterialApp` and every page: the desk's theme
/// on a wide window ([GarageTheme.desktop]), snackbars sized to the window
/// and the new-version notice. Whatever else every page should sit inside,
/// the desktop layer's additions for a wide window included, goes here as
/// well.
///
/// One widget, used by `lib/main.dart` and by `test/support/pump_screen.dart`,
/// so a screen test sees the window the app draws in. Before it, the harness
/// had the app's theme and nothing else, and a desktop-only change to what
/// sits around a page could not fail a test.
///
/// The tree keeps one shape on both sides of the wide breakpoint. A wrapper
/// present on only one side replaces everything under it when a window is
/// resized across the line, [UpdateNotice]'s state included, and a reader
/// who has been told of a new version would be told again.
class GarageAppFrame extends StatelessWidget {
  const GarageAppFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: GarageBreakpoints.isWide(context)
          ? GarageTheme.desktop(theme)
          : theme,
      child: WindowSnackBars(child: UpdateNotice(child: child)),
    );
  }
}
