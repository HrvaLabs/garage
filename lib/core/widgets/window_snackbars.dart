import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/garage_tokens.dart';
import 'adaptive.dart';

/// Sizes and places every snackbar for the window it is shown in.
///
/// Sheets and dialogs are modal routes under the root navigator, so their
/// `ScaffoldMessenger.of(context)` is the app's root messenger whatever
/// scaffold the page below uses; a messenger scoped to the content pane never
/// sees them. Left to itself the root snackbar spans the window, sidebar
/// included, so the window decides where it goes. On a phone-sized window it
/// floats, centred, at least 16 pixels in from either edge and at most
/// [maxWidth] wide.
///
/// On a wide window a notice is a toast in the bottom right corner, the width
/// of a sidebar or two, clear of the content it is usually about. Same
/// messages, same actions: only the placement is the window's (decision 198).
/// A width would centre it, so a margin as wide as the rest of the window
/// puts it in the corner; the margin lets a click through to the page, and
/// only the toast takes one.
class WindowSnackBars extends StatelessWidget {
  const WindowSnackBars({required this.child, super.key});

  final Widget child;

  /// The most a snackbar takes on a phone-sized window.
  static const double maxWidth = 560;

  /// A notice's width on a wide window.
  static const double toastWidth = 400;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final SnackBarThemeData notices;
        if (GarageBreakpoints.isWide(context)) {
          const edge = GarageTokens.space6;
          notices = theme.snackBarTheme.copyWith(
            behavior: SnackBarBehavior.floating,
            insetPadding: EdgeInsets.fromLTRB(
              math.max(edge, constraints.maxWidth - toastWidth - edge),
              0,
              edge,
              edge,
            ),
          );
        } else {
          notices = theme.snackBarTheme.copyWith(
            behavior: SnackBarBehavior.floating,
            width: math.min(maxWidth, constraints.maxWidth - 32),
          );
        }
        return Theme(
          data: theme.copyWith(snackBarTheme: notices),
          child: child,
        );
      },
    );
  }
}
