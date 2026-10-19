import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/router/page_location.dart';
import 'package:go_router/go_router.dart';

/// Something on a page that changes while it is up, as a garage loading or
/// a resized window does.
final _tick = ValueNotifier<int>(0);

/// A page that says where it thinks it is, asked again on every [_tick].
class _Where extends StatelessWidget {
  const _Where(this.name);

  final String name;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: _tick,
    builder: (context, _, _) => Text('$name at ${pageLocation(context)}'),
  );
}

Future<GoRouter> _pumpRouter(
  WidgetTester tester,
  String initialLocation,
) async {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Where('home')),
      GoRoute(path: '/stats', builder: (_, _) => const _Where('stats')),
      GoRoute(
        path: '/vehicles/:id/fuel',
        builder: (_, _) => const _Where('fuel'),
      ),
    ],
    // As the app's router does: a page of its own for an address nothing
    // matches, which go_router builds with no route state behind it.
    errorBuilder: (_, _) => const _Where('nowhere'),
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('outside a router it is the root, which only a test builds', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _Where('bare'))),
    );

    expect(find.text('bare at /'), findsOneWidget);
  });

  testWidgets('a page is at its own path, without the query', (tester) async {
    await _pumpRouter(tester, '/vehicles/v1/fuel?from=timeline');

    expect(find.text('fuel at /vehicles/v1/fuel'), findsOneWidget);
  });

  testWidgets('a page under a pushed one is still where it is', (tester) async {
    final router = await _pumpRouter(tester, '/');

    router.push('/stats');
    await tester.pumpAndSettle();

    expect(find.text('stats at /stats'), findsOneWidget);
    final home = tester.element(find.text('home at /', skipOffstage: false));
    expect(pageLocation(home), '/');
  });

  testWidgets('the page for an address nothing matches is at that address', (
    tester,
  ) async {
    await _pumpRouter(tester, '/no-such-page?token=secret');

    expect(tester.takeException(), isNull);
    expect(find.text('nowhere at /no-such-page'), findsOneWidget);
  });

  testWidgets('and is asked again as it leaves without throwing', (
    tester,
  ) async {
    // Left for the dashboard, it is still drawn while the dashboard arrives,
    // and by then the router is at an address with route state behind it.
    final router = await _pumpRouter(tester, '/no-such-page');

    router.go('/');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.textContaining('nowhere'), findsOneWidget);
    _tick.value++;
    await tester.pump();

    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(find.text('home at /'), findsOneWidget);
  });

  testWidgets('and so is one pushed onto a page', (tester) async {
    final router = await _pumpRouter(tester, '/');

    router.push('/no-such-page');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('nowhere at /no-such-page'), findsOneWidget);
  });
}
