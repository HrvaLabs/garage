import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/web/browser_menu.dart';
import 'package:garage/core/widgets/page_scaffold.dart';

import '../../support/browser.dart';
import '../../support/pump_screen.dart';

/// The switch as the web build has it, thrown through [disable], and put
/// back as the app starts when the test ends.
void _asTheWebWith(Future<void> Function() disable) {
  final web = BrowserMenu.web;
  final before = BrowserMenu.disable;
  BrowserMenu.web = true;
  BrowserMenu.disable = disable;
  addTearDown(() {
    BrowserMenu.web = web;
    BrowserMenu.disable = before;
    BrowserMenu.reset();
  });
}

void main() {
  // A desk's page waits for the switch to settle before it draws its content
  // (`SelectablePage`). A switch that never settled would leave every desk
  // page empty for good, so one that fails settles all the same, and says
  // why where errors are told.
  test('a switch that throws as it is thrown still settles, and the error '
      'goes on', () async {
    _asTheWebWith(() => throw StateError('no browser to ask'));
    final errors = <Object>[];

    runZonedGuarded(
      () => BrowserMenu.follow(wide: true),
      (error, stack) => errors.add(error),
    );
    await pumpEventQueue();

    expect(BrowserMenu.settled.value, isTrue);
    expect(errors.single, isA<StateError>());
  });

  test('and so does one whose answer is a refusal', () async {
    _asTheWebWith(() => Future.error(StateError('refused')));
    final errors = <Object>[];

    runZonedGuarded(
      () => BrowserMenu.follow(wide: true),
      (error, stack) => errors.add(error),
    );
    await pumpEventQueue();

    expect(BrowserMenu.settled.value, isTrue);
    expect(errors.single, isA<StateError>());
  });

  // The switch keeps what it was last asked between tests, as a browser
  // would. A test that threw it by hand and left it waiting would otherwise
  // hand the next one a page that never draws.
  testWidgets('a test of the web\'s half starts from the browser as it '
      'starts', (tester) async {
    BrowserMenu.web = true;
    BrowserMenu.disable = () => Completer<void>().future;
    BrowserMenu.follow(wide: true);
    BrowserMenu.web = false;
    BrowserMenu.disable = BrowserContextMenu.disableContextMenu;
    expect(BrowserMenu.settled.value, isFalse, reason: 'left waiting');

    final browser = asTheWeb(tester);
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Fuel', body: Text('52.3 L')),
      initialLocation: '/vehicles/v1/fuel',
    );
    await tester.pumpAndSettle();

    expect(browser.contextMenuCalls, ['disableContextMenu']);
    expect(find.text('52.3 L'), findsOneWidget);
  });
}
