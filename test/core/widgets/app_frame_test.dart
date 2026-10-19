import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/web/browser_menu.dart';
import 'package:garage/core/web/update_notice.dart';
import 'package:garage/core/widgets/adaptive.dart';
import 'package:garage/core/widgets/app_frame.dart';
import 'package:garage/core/widgets/page_scaffold.dart';

import '../../support/browser.dart';
import '../../support/pump_screen.dart';

/// The harness built the router with the app's theme and none of what the
/// app puts around its pages, so a change to the desktop theme or the notice
/// host would have been invisible to every screen test.
void main() {
  testWidgets('a screen under test sits in the frame the app uses', (
    tester,
  ) async {
    await pumpScreen(tester, const Text('page'));
    await tester.pumpAndSettle();

    expect(
      find.ancestor(
        of: find.text('page'),
        matching: find.byType(GarageAppFrame),
      ),
      findsOneWidget,
    );
  });

  testWidgets('and so does a desktop one', (tester) async {
    await pumpDesktop(tester, const Text('page'));
    await tester.pumpAndSettle();

    expect(tester.view.physicalSize, desktopSurface);
    expect(find.byType(GarageAppFrame), findsOneWidget);
  });

  test('the app builds its router inside the same frame', () {
    expect(
      File('lib/main.dart').readAsStringSync(),
      contains('builder: (context, child) => GarageAppFrame(child: child!)'),
    );
  });

  testWidgets('a window resized across the wide breakpoint keeps the '
      'new-version notice it had', (tester) async {
    // A wrapper that comes and goes with the window's width replaces what is
    // under it, and a notice started again asks again and tells a reader who
    // has already been told.
    var asks = 0;
    await pumpScreen(
      tester,
      const Scaffold(body: Text('page')),
      overrides: [
        updateCheckEnabledProvider.overrideWithValue(true),
        publishedBuildProvider.overrideWithValue(() async {
          asks++;
          return '999999';
        }),
      ],
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('A new version of Garage is ready'), findsOneWidget);
    final notice = tester.state(find.byType(UpdateNotice));

    tester.view.physicalSize = desktopSurface;
    await tester.pumpAndSettle();

    expect(GarageBreakpoints.isWide(tester.element(find.text('page'))), isTrue);
    expect(tester.state(find.byType(UpdateNotice)), same(notice));
    expect(asks, 1);
  });

  testWidgets('a page pushed over another is still on top after the window '
      'crosses the breakpoint and back', (tester) async {
    // The router keeps its pages across the line and back, the frame above
    // it keeping one shape at every width. go_router holds its navigator by
    // a global key, which would carry it even into a second shape; what a
    // second shape loses is what sits between, the notice in the test above.
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Statistics', body: Text('under')),
      initialLocation: '/stats',
    );
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(
          MaterialPageRoute<void>(
            builder: (context) => const GaragePageScaffold(
              title: 'Calculator',
              body: Text('on top'),
            ),
          ),
        );
    await tester.pumpAndSettle();
    final navigator = tester.state(find.byType(Navigator).first);

    for (final size in const [Size(400, 900), desktopSurface]) {
      tester.view.physicalSize = size;
      await tester.pumpAndSettle();

      expect(find.text('on top'), findsOneWidget, reason: 'at $size');
      expect(find.text('under'), findsNothing, reason: 'at $size');
    }
    expect(tester.state(find.byType(Navigator).first), same(navigator));
  });

  // On a wide window a right-click is the app's: a row's menu, or the
  // selection's Copy, and a field's own cut, copy and paste. A phone-sized
  // browser keeps the browser's, its spelling suggestions with it. The frame
  // sees the window's width, so it throws the switch, as the window crosses
  // the line and at no other time.
  group('the browser\'s own right-click menu', () {
    const page = Scaffold(body: Text('page'));

    testWidgets('goes off at a wide window and comes back as it narrows', (
      tester,
    ) async {
      final browser = asTheWeb(tester);
      await pumpDesktop(tester, page);
      await tester.pumpAndSettle();
      expect(browser.contextMenuCalls, ['disableContextMenu']);

      tester.view.physicalSize = const Size(400, 900);
      await tester.pumpAndSettle();
      expect(browser.contextMenuCalls, [
        'disableContextMenu',
        'enableContextMenu',
      ]);

      tester.view.physicalSize = desktopSurface;
      await tester.pumpAndSettle();
      expect(browser.contextMenuCalls, [
        'disableContextMenu',
        'enableContextMenu',
        'disableContextMenu',
      ]);
    });

    testWidgets('is left as the browser has it at a phone\'s width', (
      tester,
    ) async {
      final browser = asTheWeb(tester);
      await pumpScreen(tester, page);
      await tester.pumpAndSettle();
      expect(browser.contextMenuCalls, isEmpty);

      tester.view.physicalSize = desktopSurface;
      await tester.pumpAndSettle();
      expect(browser.contextMenuCalls, ['disableContextMenu']);
    });

    testWidgets('is asked once however the window moves on one side of the '
        'line', (tester) async {
      final browser = asTheWeb(tester);
      await pumpDesktop(tester, page);
      await tester.pumpAndSettle();
      for (final size in const [Size(1000, 800), Size(1300, 700)]) {
        tester.view.physicalSize = size;
        await tester.pumpAndSettle();
      }
      expect(browser.contextMenuCalls, ['disableContextMenu']);

      for (final size in const [Size(400, 900), Size(600, 800)]) {
        tester.view.physicalSize = size;
        await tester.pumpAndSettle();
      }
      expect(browser.contextMenuCalls, [
        'disableContextMenu',
        'enableContextMenu',
      ]);
    });

    testWidgets('is never asked about off the web', (tester) async {
      final calls = <String>[];
      final messenger = tester.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.contextMenu, (
        call,
      ) async {
        calls.add(call.method);
        return null;
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(
          SystemChannels.contextMenu,
          null,
        ),
      );

      await pumpDesktop(tester, page);
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(400, 900);
      await tester.pumpAndSettle();

      expect(calls, isEmpty);
    });

    // The framework's own switch is what the frame throws: it is what tells
    // the selection and the fields to draw their own menus once the
    // browser's is off. It refuses to be thrown off the web, before it says
    // anything to the browser, so a test of the web's half puts the same
    // call in its place.
    test('the switch thrown is the framework\'s own', () {
      expect(BrowserMenu.disable, same(BrowserContextMenu.disableContextMenu));
      expect(BrowserMenu.enable, same(BrowserContextMenu.enableContextMenu));
    });
  });
}
