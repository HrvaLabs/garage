import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/app_info.dart';
import 'package:garage/core/web/update_notice.dart';
import 'package:garage/l10n/app_localizations.dart';

Future<void> pumpNotice(
  WidgetTester tester, {
  required Future<String?> Function() published,
  Future<void> Function()? reload,

  /// Whether this build checks at all; only the web's does.
  bool enabled = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        updateCheckEnabledProvider.overrideWithValue(enabled),
        publishedBuildProvider.overrideWithValue(published),
        pageReloaderProvider.overrideWithValue(reload ?? () async {}),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => UpdateNotice(child: child!),
        home: const Scaffold(body: SizedBox()),
      ),
    ),
  );
  // The first check runs after the first frame; this lets it answer, and lets
  // a notice finish coming in: until it has, it is below the bottom of the
  // screen and a tap on it lands on nothing.
  await tester.pump();
  await tester.pumpAndSettle();
}

/// The periodic check and the notice's own timer both end with the tree.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

/// The tab or the window coming back, as the browser reports it.
Future<void> comeBack(WidgetTester tester) async {
  for (final state in [AppLifecycleState.inactive, AppLifecycleState.resumed]) {
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      SystemChannels.lifecycle.name,
      SystemChannels.lifecycle.codec.encodeMessage(state.toString()),
      (_) {},
    );
  }
  await tester.pump();
  await tester.pumpAndSettle();
}

/// Puts the notice on screen away, so one queued behind it would come in.
Future<void> dismiss(WidgetTester tester) async {
  tester
      .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
      .hideCurrentSnackBar();
  await tester.pumpAndSettle();
}

void main() {
  group('whether the server has a newer build', () {
    test('a larger build number is newer', () {
      expect(isNewerBuild(running: '120', published: '121'), isTrue);
    });
    test('the same one is not', () {
      expect(isNewerBuild(running: '121', published: '121'), isFalse);
    });
    test('an older one is not', () {
      expect(isNewerBuild(running: '121', published: '120'), isFalse);
    });
    test('an answer that is not a number is not', () {
      expect(isNewerBuild(running: '121', published: null), isFalse);
      expect(isNewerBuild(running: '121', published: 'abc'), isFalse);
    });
  });

  testWidgets('a newer build on the server says so, with a way to reload', (
    tester,
  ) async {
    var reloads = 0;
    await pumpNotice(
      tester,
      published: () async => '999999',
      reload: () async => reloads++,
    );

    expect(find.text('A new version of Garage is ready'), findsOneWidget);
    await tester.tap(find.text('Reload'));
    await tester.pump();
    expect(reloads, 1);

    await unmount(tester);
  });

  testWidgets('the build that is running says nothing', (tester) async {
    await pumpNotice(tester, published: () async => AppInfo.build);

    expect(find.byType(SnackBar), findsNothing);
    await unmount(tester);
  });

  testWidgets('a server that cannot be read says nothing', (tester) async {
    await pumpNotice(tester, published: () async => throw Exception('offline'));

    expect(find.byType(SnackBar), findsNothing);
    await unmount(tester);
  });

  testWidgets('coming back to the tab asks again', (tester) async {
    var serving = AppInfo.build;
    await pumpNotice(tester, published: () async => serving);
    expect(find.byType(SnackBar), findsNothing);

    serving = '999999';
    await comeBack(tester);

    expect(find.text('A new version of Garage is ready'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('a reader once told is not told again by a later check', (
    tester,
  ) async {
    var asks = 0;
    await pumpNotice(
      tester,
      published: () async {
        asks++;
        return '999999';
      },
    );
    expect(find.text('A new version of Garage is ready'), findsOneWidget);

    await comeBack(tester);
    await tester.pump(UpdateNotice.interval);
    await tester.pumpAndSettle();

    expect(asks, 1);
    await dismiss(tester);
    expect(find.byType(SnackBar), findsNothing);
    await unmount(tester);
  });

  testWidgets('two checks waiting on the server at once tell the reader once', (
    tester,
  ) async {
    final answer = Completer<String?>();
    await pumpNotice(tester, published: () => answer.future);

    // The first frame's check is still waiting when the tab comes back.
    await comeBack(tester);
    answer.complete('999999');
    await tester.pumpAndSettle();

    expect(find.text('A new version of Garage is ready'), findsOneWidget);
    await dismiss(tester);
    expect(find.byType(SnackBar), findsNothing);
    await unmount(tester);
  });

  testWidgets('a build that does not check never asks the server', (
    tester,
  ) async {
    var asks = 0;
    await pumpNotice(
      tester,
      enabled: false,
      published: () async {
        asks++;
        return '999999';
      },
    );
    await comeBack(tester);
    await tester.pump(UpdateNotice.interval);
    await tester.pumpAndSettle();

    expect(asks, 0);
    expect(find.byType(SnackBar), findsNothing);
    await unmount(tester);
  });
}
