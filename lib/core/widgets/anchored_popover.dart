import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/garage_theme.dart';
import '../theme/garage_tokens.dart';
import 'adaptive.dart';
import 'pointer_anchor.dart';

/// Shows [builder]'s content in a card that hangs from where it was asked
/// for, turned back inside the window where it would run off an edge.
///
/// A choice on a desk is a menu by the thing clicked, not a dialog in the
/// middle of the monitor (decision 199). Dismissed by a click outside or
/// Escape, as a menu is; nothing is picked then.
///
/// It hangs from the first of these there is:
/// - the last press ([PointerAnchor]), unless a key has been pressed since;
///   a press on the control that stands for [standIn] hangs it from that
///   control instead, below it, as a menu button's menu opens;
/// - the control on the page on top that stands for [standIn]
///   ([PopoverStandIn]): a key that opens the quick-add has no control of
///   its own, and the top bar's Add is the one that means the same;
/// - the focused control, as when Enter pressed it, though not a focus that
///   is the page's own;
/// - nothing, and then it is centred over the page's content pane
///   ([PopoverPane]), or the window's middle when the page has none.
Future<T?> showAnchoredPopover<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  double maxWidth = GarageBreakpoints.dialogMaxWidth,
  Object? standIn,
}) {
  final navigator = Navigator.of(context, rootNavigator: true);
  final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
  return navigator.push(
    _AnchoredPopoverRoute<T>(
      anchor: _anchor(overlay, standIn),
      pane: _pane(overlay),
      builder: builder,
      maxWidth: maxWidth,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    ),
  );
}

/// The control that stands for [action] on its page.
///
/// A popover [action] opens from a key has no press to hang from, and the
/// focus may be anywhere on the page, or on the page as a whole. Passed the
/// same [action] as `standIn`, [showAnchoredPopover] hangs it from this
/// control, below it: opened from a key, and pressed here too, where hung
/// from the press it would cover the control's lower half.
class PopoverStandIn extends StatefulWidget {
  const PopoverStandIn({required this.action, required this.child, super.key});

  /// What this control does, compared with `==`: the function it calls
  /// reads best.
  final Object action;
  final Widget child;

  @override
  State<PopoverStandIn> createState() => _PopoverStandInState();
}

class _PopoverStandInState extends State<PopoverStandIn> with _Landmark {
  static final _onScreen = <_PopoverStandInState>{};

  @override
  void initState() {
    super.initState();
    _onScreen.add(this);
  }

  @override
  void dispose() {
    _onScreen.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// The part of a desk page beside its sidebar, where the page is.
///
/// A popover with nothing to hang from is centred over it rather than over
/// the window, which would put it partly over the sidebar.
class PopoverPane extends StatefulWidget {
  const PopoverPane({required this.child, super.key});

  final Widget child;

  @override
  State<PopoverPane> createState() => _PopoverPaneState();
}

class _PopoverPaneState extends State<PopoverPane> with _Landmark {
  static final _onScreen = <_PopoverPaneState>{};

  @override
  void initState() {
    super.initState();
    _onScreen.add(this);
  }

  @override
  void dispose() {
    _onScreen.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// What a popover looks for on a page, found only on the page on top: every
/// page under it stays built, its own top bar and pane included.
mixin _Landmark<W extends StatefulWidget> on State<W> {
  ModalRoute<Object?>? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
  }

  Rect? _rectIn(RenderBox overlay) =>
      (_route?.isCurrent ?? true) ? _rectOf(context, overlay) : null;
}

/// Where [context] is drawn, in [overlay]'s coordinates, once it has been
/// laid out.
Rect? _rectOf(BuildContext context, RenderBox overlay) {
  if (!context.mounted) {
    return null;
  }
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) {
    return null;
  }
  return overlay.globalToLocal(box.localToGlobal(Offset.zero)) & box.size;
}

/// What the popover hangs from, a press being a rectangle with no size, or
/// null for nothing.
Rect? _anchor(RenderBox overlay, Object? standIn) {
  final control = _standIn(overlay, standIn);
  if (PointerAnchor.point case final point?) {
    final press = overlay.globalToLocal(point);
    // Pressed on the control that stands for it, it hangs from the control,
    // below it, as a desk's menu button opens its menu and as the keyboard
    // opens it: hung from the press, it covered the button's lower half.
    if (control != null && control.contains(press)) {
      return control;
    }
    return Rect.fromPoints(press, press);
  }
  if (control != null) {
    return control;
  }
  final focused = FocusManager.instance.primaryFocus;
  if (focused == null || focused is FocusScopeNode) {
    return null;
  }
  final rect = focused.context == null
      ? null
      : _rectOf(focused.context!, overlay);
  // A control, not what holds the keys for a whole page: the route's own
  // scope is skipped above, and a focus around a page is as tall as it.
  // Hung from either one's corner, a popover would sit in the window's bottom
  // left corner, over the sidebar.
  return rect != null && rect.height <= overlay.size.height / 2 ? rect : null;
}

/// Where the control that stands for [standIn] is, on the page on top.
Rect? _standIn(RenderBox overlay, Object? standIn) {
  if (standIn == null) {
    return null;
  }
  for (final control in _PopoverStandInState._onScreen) {
    if (control.widget.action == standIn) {
      if (control._rectIn(overlay) case final rect?) {
        return rect;
      }
    }
  }
  return null;
}

Rect? _pane(RenderBox overlay) {
  for (final pane in _PopoverPaneState._onScreen) {
    if (pane._rectIn(overlay) case final rect?) {
      return rect;
    }
  }
  return null;
}

class _AnchoredPopoverRoute<T> extends PopupRoute<T> {
  _AnchoredPopoverRoute({
    required this.anchor,
    required this.pane,
    required this.builder,
    required this.maxWidth,
    required this.themes,
    required this.barrierLabel,
  });

  final Rect? anchor;
  final Rect? pane;
  final WidgetBuilder builder;
  final double maxWidth;
  final CapturedThemes themes;

  @override
  final String barrierLabel;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => GarageTokens.motionFast;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return themes.wrap(
      Builder(
        builder: (context) {
          final tokens = context.tokens;
          return CustomSingleChildLayout(
            delegate: _HangFrom(
              anchor: anchor,
              pane: pane,
              padding: MediaQuery.paddingOf(context),
            ),
            // A screen reader is moved into it as into the dialog it was,
            // and told it opened as Material's own menus tell it: by name,
            // except on Apple's systems, where those give none either.
            child: Semantics(
              scopesRoute: true,
              namesRoute: true,
              explicitChildNodes: true,
              label: switch (Theme.of(context).platform) {
                TargetPlatform.iOS || TargetPlatform.macOS => null,
                TargetPlatform.android ||
                TargetPlatform.fuchsia ||
                TargetPlatform.linux ||
                TargetPlatform.windows => MaterialLocalizations.of(
                  context,
                ).popupMenuLabel,
              },
              child: Material(
                key: const Key('anchored-popover'),
                color: tokens.surface,
                elevation: 8,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(GarageTokens.radiusMd),
                  side: BorderSide(color: tokens.border),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: builder(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => FadeTransition(opacity: animation, child: child);
}

/// Below and to the right of what it hangs from, as a desktop menu opens;
/// above it when there is no room below, and ending where it ends when there
/// is none to its right. Centred over the pane when it hangs from nothing.
/// Kept a margin inside the window and clear of the system's own bars.
class _HangFrom extends SingleChildLayoutDelegate {
  const _HangFrom({
    required this.anchor,
    required this.pane,
    required this.padding,
  });

  final Rect? anchor;
  final Rect? pane;
  final EdgeInsets padding;

  EdgeInsets get _inset => padding + const EdgeInsets.all(GarageTokens.space4);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.biggest).deflate(_inset);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final room = _inset.deflateRect(Offset.zero & size);
    final anchor = this.anchor;
    final Offset wanted;
    if (anchor == null) {
      wanted =
          (pane ?? Offset.zero & size).center - childSize.center(Offset.zero);
    } else {
      final fitsRight = anchor.left + childSize.width <= room.right;
      final fitsBelow = anchor.bottom + childSize.height <= room.bottom;
      final fitsAbove = anchor.top - childSize.height >= room.top;
      wanted = Offset(
        fitsRight ? anchor.left : anchor.right - childSize.width,
        fitsBelow || !fitsAbove ? anchor.bottom : anchor.top - childSize.height,
      );
    }
    return Offset(
      wanted.dx.clamp(
        room.left,
        math.max(room.left, room.right - childSize.width),
      ),
      wanted.dy.clamp(
        room.top,
        math.max(room.top, room.bottom - childSize.height),
      ),
    );
  }

  @override
  bool shouldRelayout(_HangFrom oldDelegate) =>
      anchor != oldDelegate.anchor ||
      pane != oldDelegate.pane ||
      padding != oldDelegate.padding;
}
