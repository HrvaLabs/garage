import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

/// go_router's default showed the address of the page underneath a pushed
/// one: Statistics opened from the dashboard left `/` in the address bar, so
/// no pushed page could be linked to, bookmarked or reloaded (decision 199).
void main() {
  tearDown(() => GoRouter.optionURLReflectsImperativeAPIs = false);

  testWidgets('a page pushed onto another shows its own address', (
    tester,
  ) async {
    reflectPushedPagesInAddress();
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('home')),
        GoRoute(path: '/stats', builder: (_, _) => const Text('stats')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    router.push('/stats');
    await tester.pumpAndSettle();

    final shown = router.routeInformationParser.restoreRouteInformation(
      router.routerDelegate.currentConfiguration,
    )!;
    expect(shown.uri.path, '/stats');
  });

  test('the app turns it on before it builds its router', () {
    final source = File('lib/core/router/app_router.dart').readAsStringSync();
    expect(source, contains('reflectPushedPagesInAddress();'));
    expect(
      source.indexOf('reflectPushedPagesInAddress();'),
      lessThan(source.indexOf('return GoRouter(')),
    );
  });

  // The web host serves web/api.html at /api, as it served features.html at
  // /features before the tour moved to /tour. A route there works while the
  // app navigates to it, and a reload or a shared link opens the static page
  // instead; once a pushed page shows its own address, every visit to API
  // access would have ended that way. A route under one (/api/webhooks/w1)
  // is crumbed to it.
  test('no route sits at an address the web host answers with a page', () {
    final pages = {
      for (final file in Directory('web').listSync())
        if (file.path.endsWith('.html'))
          file.uri.pathSegments.last.replaceFirst(RegExp(r'\.html$'), ''),
    };
    final routes = [
      for (final route in garageRoutes().whereType<GoRoute>()) route.path,
    ];
    expect(pages, containsAll(['api', 'features', 'privacy']));
    expect(routes, contains('/vehicles/:id'));

    expect(
      [
        for (final route in routes)
          if (pages.contains(Uri.parse(route).pathSegments.firstOrNull)) route,
      ],
      isEmpty,
      reason: 'the host answers /<page> with web/<page>.html, not the app',
    );
  });
}
