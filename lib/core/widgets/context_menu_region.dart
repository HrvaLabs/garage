import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'adaptive.dart';

/// A row's own menu on a right-click, as well as behind its ⋮ (decision
/// 199).
///
/// Given the same items and handler as the row's `PopupMenuButton`, and
/// [enabled] where that button is shown, a right-click anywhere on the row
/// opens them at the pointer, as a list on a desk does. A wide window's
/// only: a phone has no right-click, and a long press there is the row's
/// already. The region is there at every width with nothing to do on a
/// phone, so a window resized across the line keeps the row under it.
///
/// The right-click is the row's alone. On a desk in a browser the page's
/// text is a selection, whose own right-click shows Copy and Select all, and
/// held past the moment a tap becomes a press it showed them over the row's
/// menu. The row claims the press as the button goes down, so the selection
/// is told it lost the press and shows nothing. The menu is a route, as the
/// ⋮'s is, so the page's keys go quiet under it.
class ContextMenuRegion<T> extends StatelessWidget {
  const ContextMenuRegion({
    required this.itemBuilder,
    required this.onSelected,
    required this.child,
    this.enabled = true,
    super.key,
  });

  /// The row's ⋮'s items.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// The row's ⋮'s handler: called with the value chosen, never on a menu
  /// put away with nothing chosen. A menu whose items act themselves
  /// (`PopupMenuItem.onTap`) passes one that does nothing.
  final PopupMenuItemSelected<T> onSelected;

  /// Whether the row has a menu: false where its ⋮ is not shown.
  final bool enabled;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final open = enabled && GarageBreakpoints.isWide(context);
    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      // A right-click has nothing to say to a screen reader: the ⋮ beside
      // it is the row's menu there.
      excludeFromSemantics: true,
      gestures: {
        _RightClick: GestureRecognizerFactoryWithHandlers<_RightClick>(
          () => _RightClick(debugOwner: this),
          (recognizer) => recognizer.onSecondaryTapDown = open
              ? (details) => _open(context, details.globalPosition)
              : null,
        ),
      },
      child: child,
    );
  }

  Future<void> _open(BuildContext context, Offset position) async {
    final items = itemBuilder(context);
    if (items.isEmpty) {
      return;
    }
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final value = await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
        overlay.globalToLocal(position) & Size.zero,
        Offset.zero & overlay.size,
      ),
      items: items,
    );
    if (value != null && context.mounted) {
      onSelected(value);
    }
  }
}

/// A press of the secondary button, the row's from the moment it goes down.
///
/// A tap is decided only when the button comes up, or when it has been held
/// past the moment a tap becomes a press. The selection around the row hears
/// the press at that moment too, and shows its own menu, so the row takes
/// the press at once and the selection is told it lost it.
class _RightClick extends TapGestureRecognizer {
  _RightClick({super.debugOwner}) : super(allowedButtonsFilter: _secondary);

  static bool _secondary(int buttons) => buttons == kSecondaryButton;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}
