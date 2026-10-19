import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/routed_tabs.dart';
import 'package:go_router/go_router.dart';

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

Widget _page({int initialIndex = 0}) => RoutedTabs(
  names: const ['drivers', 'deadlines'],
  initialIndex: initialIndex,
  child: const Scaffold(
    body: Column(
      children: [
        _Counter(),
        TabBar(
          tabs: [
            Tab(text: 'Drivers'),
            Tab(text: 'Deadlines'),
          ],
        ),
        Expanded(
          child: TabBarView(children: [Text('first tab'), Text('second tab')]),
        ),
      ],
    ),
  ),
);

GoRouter _router(WidgetTester tester) =>
    GoRouter.of(tester.element(find.byType(TabBar)));

Uri addressOf(WidgetTester tester) =>
    _router(tester).routerDelegate.currentConfiguration.uri;

void main() {
  group('the tab opened', () {
    testWidgets('is the one its address names', (tester) async {
      await pumpScreen(
        tester,
        _page(),
        initialLocation: '/company?tab=deadlines',
      );
      await tester.pumpAndSettle();

      expect(find.text('second tab'), findsOneWidget);
      expect(find.text('first tab'), findsNothing);
    });

    testWidgets('is the first for a name it does not know', (tester) async {
      await pumpScreen(
        tester,
        _page(),
        initialLocation: '/company?tab=nonsense',
      );
      await tester.pumpAndSettle();

      expect(find.text('first tab'), findsOneWidget);
    });

    testWidgets('is the page\'s own when its address names none', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        _page(initialIndex: 1),
        initialLocation: '/company',
      );
      await tester.pumpAndSettle();

      expect(find.text('second tab'), findsOneWidget);
    });

    testWidgets('and the address\'s when it names one', (tester) async {
      await pumpScreen(
        tester,
        _page(initialIndex: 1),
        initialLocation: '/company?tab=drivers',
      );
      await tester.pumpAndSettle();

      expect(find.text('first tab'), findsOneWidget);
    });
  });

  group('on the web', () {
    testWidgets('a tab moved to is written to the address', (tester) async {
      asTheWeb(tester);
      await pumpScreen(tester, _page(), initialLocation: '/company');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();

      expect(addressOf(tester).queryParameters['tab'], 'deadlines');
      expect(addressOf(tester).path, '/company');
    });

    testWidgets('and the page is kept, not built again', (tester) async {
      asTheWeb(tester);
      await pumpScreen(tester, _page(), initialLocation: '/company');
      await tester.pumpAndSettle();
      await tester.tap(find.text('tapped 0'));
      await tester.pump();
      final counter = tester.state(find.byType(_Counter));

      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Drivers'));
      await tester.pumpAndSettle();

      expect(addressOf(tester).queryParameters['tab'], 'drivers');
      expect(tester.state(find.byType(_Counter)), same(counter));
      expect(find.text('tapped 1'), findsOneWidget);
    });

    testWidgets('the tabs follow the address when it changes underneath', (
      tester,
    ) async {
      asTheWeb(tester);
      await pumpScreen(
        tester,
        _page(),
        initialLocation: '/company?tab=deadlines',
      );
      await tester.pumpAndSettle();

      _router(tester).replace('/company?tab=drivers');
      await tester.pumpAndSettle();

      expect(find.text('first tab'), findsOneWidget);
    });

    testWidgets('an address without a tab is followed, and not written over', (
      tester,
    ) async {
      asTheWeb(tester);
      await pumpScreen(
        tester,
        _page(),
        initialLocation: '/company?tab=deadlines',
      );
      await tester.pumpAndSettle();

      _router(tester).replace('/company');
      await tester.pumpAndSettle();

      expect(find.text('first tab'), findsOneWidget);
      expect(addressOf(tester).toString(), '/company');
    });

    testWidgets('Back returns to the tab before, then leaves the page', (
      tester,
    ) async {
      final browser = asTheWeb(tester);
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Text('the list')),
          GoRoute(path: '/company', builder: (_, _) => _page()),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.push('/company');
      await tester.pumpAndSettle();
      await tester.tap(find.text('tapped 0'));
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();
      expect(browser.address.toString(), '/company?tab=deadlines');
      expect(browser.depth, 3);

      await browser.back();
      await tester.pumpAndSettle();

      expect(find.text('first tab'), findsOneWidget);
      expect(find.text('tapped 1'), findsOneWidget);
      // Following the address wrote nothing over the entry Back went to,
      // so Forward still has the tab that was left.
      expect(browser.address.toString(), '/company');
      expect(browser.depth, 2);

      await browser.back();
      await tester.pumpAndSettle();

      expect(find.text('the list'), findsOneWidget);
    });
  });

  // A tab is written when the tabs stop moving, and a row tapped meanwhile
  // can push a page before then; `replace` rewrites the router's top page,
  // whichever page that is.
  testWidgets('on the web a page pushed while the tabs move is left alone', (
    tester,
  ) async {
    final browser = asTheWeb(tester);
    final router = GoRouter(
      initialLocation: '/company',
      routes: [
        GoRoute(path: '/company', builder: (_, _) => _page()),
        GoRoute(
          path: '/company/tyres',
          builder: (_, _) => const Scaffold(body: Text('the pushed page')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Deadlines'));
    await tester.pump();
    router.push('/company/tyres');
    await tester.pumpAndSettle();

    expect(find.text('the pushed page'), findsOneWidget);
    expect(browser.address.toString(), '/company/tyres');
  });

  // A dialog is no page of the router's: the page under it is still its top,
  // and the tab moved to is still written.
  testWidgets(
    'on the web a dialog opened while the tabs move lets them write',
    (tester) async {
      asTheWeb(tester);
      await pumpScreen(tester, _page(), initialLocation: '/company');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Deadlines'));
      await tester.pump();
      showDialog<void>(
        context: tester.element(find.byType(TabBar)),
        builder: (context) => const Text('over the page'),
      );
      await tester.pumpAndSettle();

      expect(find.text('over the page'), findsOneWidget);
      expect(addressOf(tester).queryParameters['tab'], 'deadlines');
    },
  );

  group('off the web', () {
    testWidgets('a tab moved to leaves the address alone', (tester) async {
      await pumpScreen(tester, _page(), initialLocation: '/company');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();

      expect(find.text('second tab'), findsOneWidget);
      expect(addressOf(tester).toString(), '/company');
    });

    // The address still names the tab the page opened on. A dialog over the
    // page tells everything under it that the page is no longer on top, and
    // tabs that read that as their address changing went back to the first.
    testWidgets('a dialog over the page leaves the tab where it was', (
      tester,
    ) async {
      await pumpScreen(tester, _page(), initialLocation: '/company');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();

      showDialog<void>(
        context: tester.element(find.byType(TabBar)),
        builder: (context) => const Text('over the page'),
      );
      await tester.pumpAndSettle();
      Navigator.of(tester.element(find.text('over the page'))).pop();
      await tester.pumpAndSettle();

      expect(find.text('second tab'), findsOneWidget);
    });
  });
}
