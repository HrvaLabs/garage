import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/localization/garage_localizations.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/page_scaffold.dart';
import 'package:garage/core/widgets/page_title.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../../support/browser.dart';
import '../../support/pump_screen.dart';

/// Something on the page that would start again from nothing if the page
/// were built anew rather than kept.
class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var _taps = 0;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => _taps++),
    child: Text('tapped $_taps'),
  );
}

const _statistics = GaragePageScaffold(title: 'Statistics', body: SizedBox());

/// A page pushed over the one under test, naming the tab after itself.
Future<void> _pushCalculator(WidgetTester tester) async {
  Navigator.of(tester.element(find.byType(Scaffold).first)).push(
    MaterialPageRoute<void>(
      builder: (_) => const PageTitle(
        title: 'Calculator',
        child: Scaffold(body: Text('the calculator')),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the browser tab is named after the page', (tester) async {
    final browser = asTheWeb(tester);
    await pumpScreen(tester, _statistics, initialLocation: '/stats');
    await tester.pumpAndSettle();

    expect(browser.titles.last, 'Statistics · Garage');
  });

  // The web paints its bar in the colour that comes with the name, and in
  // black for none, so a page says the colour the app gave the window, which
  // is not its theme's: the app's is the light theme's, in the dark too.
  testWidgets('in the colour the app already gives the window', (tester) async {
    final browser = asTheWeb(tester);
    await tester.pumpWidget(
      MaterialApp(
        color: const Color(0xFF2E7D32),
        theme: ThemeData(primaryColor: const Color(0xFF6A1B9A)),
        localizationsDelegates: garageLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PageTitle(title: 'Statistics', child: SizedBox()),
      ),
    );
    await tester.pumpAndSettle();

    expect(browser.titles.last, 'Statistics · Garage');
    expect(browser.titleColours.last, 0xFF2E7D32);
  });

  testWidgets('a tab is named after itself too', (tester) async {
    final browser = asTheWeb(tester);
    await pumpScreen(
      tester,
      const GarageTabScaffold(
        current: GarageTab.timeline,
        title: 'Timeline',
        body: SizedBox(),
      ),
      initialLocation: '/timeline',
    );
    await tester.pumpAndSettle();

    expect(browser.titles.last, 'Timeline · Garage');
  });

  testWidgets('in the app\'s language', (tester) async {
    final browser = asTheWeb(tester);
    await pumpScreen(
      tester,
      const GaragePageScaffold(title: 'Statistika', body: SizedBox()),
      initialLocation: '/stats',
      locale: const Locale('hr'),
    );
    await tester.pumpAndSettle();

    expect(browser.titles.last, 'Statistika · Garaža');
  });

  // The garage's own screen is called what the app is called, in every
  // language: "Garage · Garage" says nothing twice.
  testWidgets('a page called what the app is called is named once', (
    tester,
  ) async {
    final browser = asTheWeb(tester);
    await pumpScreen(
      tester,
      const GaragePageScaffold(title: 'Garaža', body: SizedBox()),
      initialLocation: '/household',
      locale: const Locale('hr'),
    );
    await tester.pumpAndSettle();

    expect(browser.titles.last, 'Garaža');
  });

  testWidgets('the page on top names it, not one underneath', (tester) async {
    final browser = asTheWeb(tester);
    final name = ValueNotifier('Statistics');
    addTearDown(name.dispose);
    await pumpScreen(
      tester,
      ValueListenableBuilder<String>(
        valueListenable: name,
        builder: (_, value, _) =>
            GaragePageScaffold(title: value, body: const SizedBox()),
      ),
      initialLocation: '/stats',
    );
    await tester.pumpAndSettle();
    await _pushCalculator(tester);
    expect(browser.titles.last, 'Calculator · Garage');

    // A page underneath still builds when what it shows changes.
    name.value = 'Statistics for 2026';
    await tester.pumpAndSettle();

    expect(browser.titles.last, 'Calculator · Garage');
  });

  testWidgets('and is named again when it is back on top', (tester) async {
    final browser = asTheWeb(tester);
    await pumpScreen(tester, _statistics, initialLocation: '/stats');
    await tester.pumpAndSettle();
    await _pushCalculator(tester);

    Navigator.of(tester.element(find.text('the calculator'))).pop();
    await tester.pumpAndSettle();

    expect(browser.titles.last, 'Statistics · Garage');
  });

  // A menu is a route over the page, so the page stops being on top while it
  // is open. A name that came and went with that built the page again from
  // nothing, and the menu's choice went to a button no longer there.
  testWidgets('a menu over the page keeps the page and delivers its choice', (
    tester,
  ) async {
    final browser = asTheWeb(tester);
    String? chosen;
    await pumpScreen(
      tester,
      GaragePageScaffold(
        title: 'Statistics',
        actions: [
          PopupMenuButton<String>(
            key: const Key('menu'),
            onSelected: (value) => chosen = value,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'csv', child: Text('Export CSV')),
            ],
          ),
        ],
        body: const _Counter(),
      ),
      initialLocation: '/stats',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('tapped 0'));
    await tester.pump();
    final page = tester.state(find.byType(_Counter));
    final named = browser.titles.length;

    await tester.tap(find.byKey(const Key('menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Export CSV'));
    await tester.pumpAndSettle();

    expect(chosen, 'csv');
    expect(tester.state(find.byType(_Counter)), same(page));
    expect(find.text('tapped 1'), findsOneWidget);
    expect(browser.titles.length, greaterThan(named));
    expect(browser.titles.last, 'Statistics · Garage');
  });

  // On Android the same call renames the app in the recent-apps list.
  testWidgets('off the web nothing is named', (tester) async {
    final said = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemChrome.setApplicationSwitcherDescription') {
          said.add(
            (call.arguments as Map<Object?, Object?>)['label']! as String,
          );
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpScreen(tester, _statistics, initialLocation: '/stats');
    await tester.pumpAndSettle();

    expect(said, isNot(contains('Statistics · Garage')));
  });
}
