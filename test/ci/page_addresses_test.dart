import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Iterable<File> _dartFiles(String root) => Directory(root)
    .listSync(recursive: true)
    .whereType<File>()
    .where((file) => file.path.endsWith('.dart'));

/// Two promises of decision 199, held in the source, since a page that
/// breaks either still looks right in every test of its own.
void main() {
  test('a tab strip is routed, so its tab is in the address', () {
    final bare = [
      for (final file in _dartFiles('lib'))
        if (file.path != 'lib/core/widgets/routed_tabs.dart' &&
            file.readAsStringSync().contains('DefaultTabController('))
          file.path,
    ];

    expect(
      bare,
      isEmpty,
      reason:
          'a page with tabs wraps itself in RoutedTabs: a bare '
          'DefaultTabController\'s tab cannot be linked to, reloaded or '
          'gone back to',
    );
  });

  test('every screen names the browser tab', () {
    const naming = ['GaragePageScaffold(', 'GarageTabScaffold(', 'PageTitle('];
    final screens = [
      for (final file in _dartFiles('lib/features'))
        if (file.path.contains('/screens/')) file,
    ];
    expect(screens.length, greaterThan(30));

    expect(
      [
        for (final file in screens)
          if (!naming.any(file.readAsStringSync().contains)) file.path,
      ],
      isEmpty,
      reason:
          'a screen outside the two scaffolds wraps itself in PageTitle, '
          'or the browser tab keeps the name of the page before it',
    );
  });
}
