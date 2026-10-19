import 'package:flutter/material.dart';

import '../theme/garage_theme.dart';
import '../web/update_notice.dart';
import 'adaptive.dart';
import 'focus_rings.dart';
import 'pointer_anchor.dart';
import 'window_snackbars.dart';

/// What the app puts between `MaterialApp` and every page: the desk's theme
/// on a wide window ([GarageTheme.desktop]), with a ring round the button
/// the keyboard reached ([FocusRings]), snackbars sized and placed for the
/// window, the new-version notice, and the record of the last press that a
/// popover on a desk hangs from ([PointerAnchor]). Whatever else every page
/// should sit inside, the desktop layer's additions for a wide window
/// included, goes here as well.
///
/// One widget, used by `lib/main.dart` and by `test/support/pump_screen.dart`,
/// so a screen test sees the window the app draws in. Before it, the harness
/// had the app's theme and nothing else, and a desktop-only change to what
/// sits around a page could not fail a test.
///
/// The tree keeps one shape on both sides of the wide breakpoint. A wrapper
/// present on only one side replaces everything under it when a window is
/// resized across the line, [UpdateNotice]'s state included, and a reader
/// who has been told of a new version would be told again. The press is
/// recorded at every width and adds nothing to the tree: only a popover reads
/// it, and a phone has none. The rings are heard at every width too, and
/// change only the theme's data: a phone's theme has none to draw.
class GarageAppFrame extends StatefulWidget {
  const GarageAppFrame({required this.child, super.key});

  final Widget child;

  @override
  State<GarageAppFrame> createState() => _GarageAppFrameState();
}

class _GarageAppFrameState extends State<GarageAppFrame> {
  @override
  void initState() {
    super.initState();
    PointerAnchor.install();
    FocusRings.install();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: FocusRings.drawn,
      builder: (context, rings, child) => Theme(
        data: GarageBreakpoints.isWide(context)
            ? GarageTheme.desktop(theme, focusRings: rings)
            : theme,
        child: child!,
      ),
      child: WindowSnackBars(child: UpdateNotice(child: widget.child)),
    );
  }
}
