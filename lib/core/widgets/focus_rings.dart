import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// Whether a desk draws a ring round the button that has the focus: from a
/// Tab or an arrow until the next press, as a browser rings a control the
/// keyboard reached and not one a click focused (decision 199).
///
/// Flutter's own highlight mode does not tell the two apart on a desk. A
/// mouse leaves it where the keyboard put it, so a button clicked after a Tab
/// reached it would have kept its ring. `GarageAppFrame` starts this and
/// draws a wide window's theme with the rings or without them
/// (`GarageTheme.desktop`). It is heard at every width and on Android too,
/// as `PointerAnchor` is; a phone's theme has no ring to draw.
abstract final class FocusRings {
  static final _drawn = ValueNotifier<bool>(false);
  static bool _routed = false;

  /// Whether the rings are drawn now.
  static ValueListenable<bool> get drawn => _drawn;

  /// Starts listening, with no ring drawn; calling it again does no harm.
  ///
  /// The pointer's route goes in once and the keyboard's handler on every
  /// call, as `PointerAnchor.install` does: a widget test drops every
  /// keyboard handler when it ends and keeps the pointer's routes.
  static void install() {
    _drawn.value = false;
    if (!_routed) {
      _routed = true;
      GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    }
    HardwareKeyboard.instance
      ..removeHandler(_onKey)
      ..addHandler(_onKey);
  }

  static void _onPointer(PointerEvent event) {
    if (event is PointerDownEvent) {
      _drawn.value = false;
    }
  }

  /// The keys of someone using the keyboard to get about: Tab, with or
  /// without Shift, and the arrows, which move the focus in a menu, and
  /// between controls off the web; in a browser they scroll the page, and a
  /// ring then shows where the focus is.
  static final _moves = {
    LogicalKeyboardKey.tab,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
  };

  static bool _onKey(KeyEvent event) {
    // A key the system made up is not one somebody pressed.
    if (event is KeyDownEvent &&
        !event.synthesized &&
        _moves.contains(event.logicalKey)) {
      _drawn.value = true;
    }
    // Only listening: the key goes on to whoever handles it.
    return false;
  }
}
