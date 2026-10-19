import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The browser's own right-click menu: off in a browser at a wide window,
/// on everywhere else (decision 199).
///
/// On a desk a right-click is the app's: a row's menu
/// (`ContextMenuRegion`), Copy and Select all for the page's text, and a
/// field's own cut, copy and paste, which Flutter draws once the browser's
/// is off. Over the app's canvas the browser's offered little but saving the
/// page as an image. A phone-sized browser keeps it, its spelling suggestions
/// included.
///
/// `GarageAppFrame` sees the window's width, and throws the switch as the
/// window crosses the wide line and at no other time: a page's selection
/// reads it as it is built and changes shape with it, and crossing the line
/// builds the page again anyway. The framework hears that the switch has
/// been thrown only when the browser answers, after the frame that crossed
/// the line has been built, so a page's selection waits for [settled]
/// (`SelectablePage`).
abstract final class BrowserMenu {
  /// What the browser was last asked: true for off.
  static bool _offAsked = false;

  /// How many of the changes asked are still waiting for the browser.
  static int _waiting = 0;

  static final _settled = ValueNotifier<bool>(true);

  /// Whether the browser has answered every change asked of it, so the
  /// framework's word on its menu will not change under a selection built
  /// now.
  static ValueListenable<bool> get settled => _settled;

  /// Off for a wide window, on again for a narrow one; nothing for a window
  /// that stays on its side of the line, nor off the web.
  static void follow({required bool wide}) {
    if (!web || wide == _offAsked) {
      return;
    }
    _offAsked = wide;
    _waiting += 1;
    _settled.value = false;
    // Answered or refused, or refused before it was asked, the framework's
    // word stands from here, and the page stops waiting; a refusal goes on to
    // the app's error handler.
    unawaited(
      Future.sync(wide ? disable : enable).whenComplete(() {
        _waiting -= 1;
        _settled.value = _waiting == 0;
      }),
    );
  }

  /// Whether this is the web build: on the web, and in a test that asks.
  @visibleForTesting
  static bool web = kIsWeb;

  /// The framework's own switch, which tells the selection and the fields to
  /// draw their menus. It refuses to be thrown off the web, before it says
  /// anything to the browser, so a test of the web's half puts the same call
  /// to the browser in its place (`asTheWeb`).
  @visibleForTesting
  static Future<void> Function() disable =
      BrowserContextMenu.disableContextMenu;

  /// The other half of [disable].
  @visibleForTesting
  static Future<void> Function() enable = BrowserContextMenu.enableContextMenu;

  /// The browser as it starts, with its menu on and nothing asked.
  @visibleForTesting
  static void reset() {
    _offAsked = false;
    _waiting = 0;
    _settled.value = true;
  }
}
