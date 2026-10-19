import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'adaptive.dart';

/// A page's text, which on a desk in a browser can be selected and copied as
/// a web page's can (decision 199).
///
/// Both scaffolds put it around a page's content on a wide window, under the
/// top bar, so the sidebar and the bar stay controls and only the page is
/// text. A click on its text takes the keyboard, as a click in a browser
/// does, so Ctrl or ⌘ with A and C select it all and copy it. Tab passes over
/// it, as it passes over a web page, to the page's first control.
///
/// The web's alone, and a wide window's. A tablet held sideways is wide too,
/// and there, as on a phone and in a phone's browser, a long press stays the
/// row's. A chart's plot leaves itself out (`SelectionContainer.disabled`
/// around it): its labels are places on a drawing, and copied with the page
/// they read as a run of stray numbers. Its heading and legend are the page's.
class SelectablePage extends StatefulWidget {
  const SelectablePage({required this.child, super.key});

  final Widget child;

  /// Whether a desk's page can be selected: on the web, and in a test that
  /// asks.
  @visibleForTesting
  static bool web = kIsWeb;

  @override
  State<SelectablePage> createState() => _SelectablePageState();
}

class _SelectablePageState extends State<SelectablePage> {
  /// What a click on the page's text focuses, so the keys reach the
  /// selection. The area's own took a Tab too: on the way from the top bar to
  /// the page's first control, the focus stopped on the page, and nothing
  /// showed where it was.
  final _focus = FocusNode(skipTraversal: true, debugLabel: 'SelectablePage');

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      SelectablePage.web && GarageBreakpoints.isWide(context)
      ? SelectionArea(focusNode: _focus, child: widget.child)
      : widget.child;
}
