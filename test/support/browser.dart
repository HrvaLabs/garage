import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/router/app_router.dart';
import 'package:garage/core/widgets/page_title.dart';
import 'package:garage/core/widgets/routed_tabs.dart';
import 'package:go_router/go_router.dart';

/// The browser around the web build, as much of it as a test needs: the name
/// it gives the tab, and a history the app writes its addresses to and Back
/// reads them from.
class FakeBrowser {
  FakeBrowser._(this._tester);

  final WidgetTester _tester;

  /// Every name the tab was given, oldest first. Off the web the app's own
  /// `Title` names it too, once, before any page does.
  final List<String> titles = [];

  /// The colour each name came with, which the browser draws its bar in.
  final List<int?> titleColours = [];

  final List<({String uri, Object? state})> _history = [];
  int _at = -1;

  /// The address in the address bar.
  Uri get address => Uri.parse(_history[_at].uri);

  /// How many entries Back can walk through, the one on show included.
  int get depth => _at + 1;

  /// The browser's Back: the entry before, and what the app stored with it.
  Future<void> back() async {
    _at -= 1;
    final entry = _history[_at];
    await _tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      SystemChannels.navigation.name,
      SystemChannels.navigation.codec.encodeMethodCall(
        MethodCall('pushRouteInformation', {
          'location': entry.uri,
          'state': entry.state,
        }),
      ),
      (_) {},
    );
  }

  void _shown(Map<Object?, Object?> report) {
    final entry = (uri: report['uri']! as String, state: report['state']);
    if (report['replace'] == true && _at >= 0) {
      _history[_at] = entry;
      return;
    }
    _history
      ..removeRange(_at + 1, _history.length)
      ..add(entry);
    _at += 1;
  }
}

/// Runs the rest of the test as the web build: each page names the browser's
/// tab, a tab strip writes its tab to the address, and a pushed page shows its
/// own. Off in a test as on Android, so a test about the web asks for it,
/// before it pumps the app.
FakeBrowser asTheWeb(WidgetTester tester) {
  final browser = FakeBrowser._(tester);
  final titled = PageTitle.enabled;
  final writes = RoutedTabs.writesAddress;
  final reflects = GoRouter.optionURLReflectsImperativeAPIs;
  PageTitle.enabled = true;
  RoutedTabs.writesAddress = true;
  reflectPushedPagesInAddress();

  final messenger = tester.binding.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'SystemChrome.setApplicationSwitcherDescription') {
      final arguments = call.arguments as Map<Object?, Object?>;
      browser.titles.add(arguments['label']! as String);
      browser.titleColours.add(arguments['primaryColor'] as int?);
    }
    return null;
  });
  messenger.setMockMethodCallHandler(SystemChannels.navigation, (call) async {
    if (call.method == 'routeInformationUpdated') {
      browser._shown(call.arguments as Map<Object?, Object?>);
    }
    return null;
  });
  addTearDown(() {
    messenger
      ..setMockMethodCallHandler(SystemChannels.platform, null)
      ..setMockMethodCallHandler(SystemChannels.navigation, null);
    PageTitle.enabled = titled;
    RoutedTabs.writesAddress = writes;
    GoRouter.optionURLReflectsImperativeAPIs = reflects;
  });
  return browser;
}

/// Opens each tab of the strip on screen by its label, in the order given,
/// and returns the name each one wrote to the page's address.
///
/// A tab already open writes nothing, so a test that wants every name opens
/// the first tab last.
Future<List<String?>> tabNamesWritten(
  WidgetTester tester,
  List<String> labels,
) async {
  final written = <String?>[];
  for (final label in labels) {
    final tab = find.descendant(
      of: find.byType(TabBar),
      matching: find.text(label),
    );
    await tester.ensureVisible(tab);
    await tester.pumpAndSettle();
    await tester.tap(tab);
    await tester.pumpAndSettle();
    written.add(
      GoRouter.of(
        tester.element(find.byType(TabBar)),
      ).routerDelegate.currentConfiguration.uri.queryParameters['tab'],
    );
  }
  return written;
}
