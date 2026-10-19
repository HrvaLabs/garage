import 'package:flutter/material.dart';

import '../theme/garage_theme.dart';
import '../theme/garage_tokens.dart';
import 'adaptive.dart';

/// A page's main act: log a fill-up, add a car, lend it.
///
/// A floating button on a phone, where the thumb is; a button in the top bar
/// on a desk, where a floating circle over a list reads as a phone app
/// (decision 198). A screen says what the act is, and the scaffold decides
/// how it looks: this file is the only one that builds a
/// `FloatingActionButton`.
class PrimaryAction {
  const PrimaryAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.key,
    this.extended = true,
    this.showOnWide = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Key? key;

  /// Whether the phone's button carries its label. A bare + is for a button
  /// that opens a choice of things to add, and has no tooltip, as it never
  /// had: there the label is the desk's alone.
  final bool extended;

  /// False when the top bar already offers the act: the dashboard's + is the
  /// quick-add every page on a desk has.
  final bool showOnWide;

  /// The phone's button, exactly as each screen used to build it.
  Widget floating() => extended
      ? FloatingActionButton.extended(
          key: key,
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
        )
      : FloatingActionButton(key: key, onPressed: onPressed, child: Icon(icon));

  /// The desk's: the page's one filled button, in its top bar.
  Widget toolbar() => FilledButton.icon(
    key: key,
    style: GarageTheme.toolbarButton,
    onPressed: onPressed,
    icon: Icon(icon),
    label: Text(label),
  );
}

/// A tab's own primary action, for a page whose tabs each have one: the
/// car's fuel tab logs a fill-up, its upkeep tab a service.
///
/// A scaffold of its own with a floating button on a phone, as before, so the
/// button belongs to the tab rather than to the page; on a desk the button
/// sits at the right above the tab's content.
class ActionPane extends StatelessWidget {
  const ActionPane({required this.action, required this.body, super.key});

  final PrimaryAction action;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (!GarageBreakpoints.isWide(context)) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: action.floating(),
        body: body,
      );
    }
    if (!action.showOnWide) {
      return body;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            GarageTokens.space4,
            GarageTokens.space3,
            GarageTokens.space4,
            0,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: action.toolbar(),
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}
