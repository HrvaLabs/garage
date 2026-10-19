import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage/l10n/app_localizations.dart';

/// Names the browser tab after the page on screen: "Statistics · Garage"
/// (decision 199).
///
/// Said when the page comes on top, and again if its title changes while it
/// is there. Only the page on top says it: one underneath still builds when
/// what it shows changes, and would take the name from the page over it.
///
/// Always the same widget around the same child, on top or not. A menu, a
/// dialog or a popover over the page takes it off the top, and a wrapper
/// that came and went with that would build the whole page again from
/// nothing, dropping the choice being made in the menu.
///
/// The web's alone, at every width: on Android the same call renames the
/// app in the list of recent apps.
class PageTitle extends StatefulWidget {
  const PageTitle({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  /// Whether a page names the browser tab: on the web, and in a test that
  /// asks.
  @visibleForTesting
  static bool enabled = kIsWeb;

  @override
  State<PageTitle> createState() => _PageTitleState();
}

class _PageTitleState extends State<PageTitle> {
  /// What this page last named the tab while on top; null while it is not,
  /// so that coming back on top names it again.
  String? _said;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _say();
  }

  @override
  void didUpdateWidget(PageTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    _say();
  }

  void _say() {
    if (!PageTitle.enabled) {
      return;
    }
    if (!(ModalRoute.isCurrentOf(context) ?? true)) {
      _said = null;
      return;
    }
    final app = AppLocalizations.of(context)!.appTitle;
    // The garage's own screen is called what the app is: said once.
    final label = widget.title == app ? app : '${widget.title} · $app';
    if (label == _said) {
      return;
    }
    _said = label;
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: label,
        // The web paints its bar in the colour given with the name, and in
        // black when none is. The app's own title gives the window its
        // colour, so a page says that one and changes nothing but the name.
        primaryColor:
            (context.findAncestorWidgetOfExactType<Title>()?.color ??
                    Theme.of(context).primaryColor)
                .toARGB32(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
