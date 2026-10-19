import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// Where the last press landed, so a choice it opened can appear there.
///
/// On a desk a menu opens beside what was clicked. `showPickOne` and its kin
/// are handed a context that is usually the whole screen's, not the chip's,
/// so the press itself is the one reliable record of where "there" is. A key
/// pressed since forgets it: a choice opened from the keyboard hangs from
/// something else, which `showAnchoredPopover` finds (decision 199).
///
/// `GarageAppFrame` starts it, so it records presses at every width and on
/// every platform. Only a popover reads it, and a phone has none.
abstract final class PointerAnchor {
  static Offset? _lastDown;
  static bool _routed = false;

  /// Starts listening; calling it again does no harm.
  ///
  /// The pointer's route goes in once. The keyboard's handler is put back on
  /// every call: a widget test drops every keyboard handler when it ends and
  /// keeps the pointer's routes, and a handler added only the first time was
  /// gone from the second test on.
  static void install() {
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
      _lastDown = event.position;
    }
  }

  static bool _onKey(KeyEvent event) {
    // Not one the system made up: the web build reports a modifier it finds
    // held on a pointer event, pressed while the window was elsewhere, as a
    // key going down, and nobody turned to the keyboard.
    if (event is KeyDownEvent && !event.synthesized) {
      _lastDown = null;
    }
    // Only listening: the key goes on to whoever handles it.
    return false;
  }

  /// The last press, in window coordinates, or null when nothing has been
  /// pressed or a key has been since.
  ///
  /// Null on the web while the accessibility layer is on: the web build then
  /// hands a click on anything tappable to the app as an accessibility tap
  /// and keeps the press back, so the last press it did pass on was another
  /// one, a field's or the page's, and a choice hung from it opened nowhere
  /// near what was clicked.
  static Offset? get point =>
      web && SemanticsBinding.instance.semanticsEnabled ? null : _lastDown;

  /// Whether this is the web build: on the web, and in a test that asks.
  @visibleForTesting
  static bool web = kIsWeb;

  @visibleForTesting
  static void reset() => _lastDown = null;
}
