import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/web/update_notice.dart';
import 'package:garage/core/widgets/adaptive.dart';
import 'package:garage/core/widgets/app_frame.dart';

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
}
