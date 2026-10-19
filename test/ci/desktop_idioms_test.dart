import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A desk is not a big phone (decision 200): on a wide window no floating
/// button, no bottom bar or bottom sheet, no Material date picker, no ripple
/// chosen by hand, no snackbar placed by anyone but its host, and no
/// navigation rail. Each phone idiom is allowed in exactly one file, the
/// adaptive one that shows it on a phone and something else on a desk, the
/// way `modal_surfaces_test.dart` holds the modal helpers.
///
/// It reads the source, so it holds what is written, not what is drawn. A
/// button that floats itself in a `Stack` is not a `FloatingActionButton`,
/// and passes; a `//` inside a string within a string's `${}` is read as a
/// comment, and hides the rest of its line; and in a `SnackBar`'s own
/// arguments a ternary whose first branch is a variable called `width`,
/// `margin` or `behavior` (`wide ? width : null`) reads as that argument
/// given, and fails.
void main() {
  /// Strings and comments, whichever starts first: a `//` inside a string, a
  /// URL's say, is part of the string, and what follows it on the line is
  /// still read.
  final stringOrComment = RegExp(
    r"r'''[\s\S]*?'''|"
    r'r"""[\s\S]*?"""|'
    r"'''(?:\\[\s\S]|[^\\])*?'''|"
    r'"""(?:\\[\s\S]|[^\\])*?"""|'
    r"r'[^'\n]*'|"
    r'r"[^"\n]*"|'
    r"'(?:\\.|[^'\\\n])*'|"
    r'"(?:\\.|[^"\\\n])*"|'
    r'//[^\n]*|'
    r'/\*[\s\S]*?\*/',
  );

  /// The file with its comments taken out: a doc comment that names a widget
  /// to explain why it is not used is not a use. Strings stay, so a name in
  /// one counts; with [strings] false each is emptied, for reading brackets.
  String code(File file, {bool strings = true}) =>
      file.readAsStringSync().replaceAllMapped(stringOrComment, (match) {
        final text = match[0]!;
        if (text.startsWith('/')) {
          return ' ';
        }
        return strings ? text : "''";
      });

  final sources = [
    for (final entity in Directory('lib').listSync(recursive: true))
      if (entity is File &&
          entity.path.endsWith('.dart') &&
          !entity.path.contains('/l10n/'))
        entity,
  ];

  List<String> using(String pattern) => [
    for (final file in sources)
      if (RegExp(pattern).hasMatch(code(file))) file.path,
  ]..sort();

  /// The named arguments a call to [constructor] is given directly, not those
  /// of the widgets inside it, each as `path: name`.
  List<String> argumentsOf(String constructor, Set<String> names) {
    final found = <String>[];
    final call = RegExp('\\b$constructor\\(');
    final argument = RegExp('\\b(${names.join('|')})\\s*:');
    for (final file in sources) {
      final text = code(file, strings: false);
      for (final start in call.allMatches(text)) {
        final own = StringBuffer();
        var depth = 1;
        for (var i = start.end; i < text.length && depth > 0; i++) {
          final char = text[i];
          if ('([{'.contains(char)) {
            depth++;
          } else if (')]}'.contains(char)) {
            depth--;
          }
          own.write(depth == 1 && !')]}'.contains(char) ? char : ' ');
        }
        for (final match in argument.allMatches(own.toString())) {
          found.add('${file.path}: ${match[1]}');
        }
      }
    }
    return found..sort();
  }

  test('a floating button is built by the primary action alone', () {
    expect(using(r'\bFloatingActionButton\b'), [
      'lib/core/widgets/primary_action.dart',
    ]);
  });

  test('and only a primary action is given the floating slot', () {
    expect(using(r'\bfloatingActionButton\s*:'), [
      'lib/core/widgets/garage_bottom_nav.dart',
      'lib/core/widgets/page_scaffold.dart',
      'lib/core/widgets/primary_action.dart',
    ]);
  });

  test('a bottom bar only in the tab scaffold, which a desk gives a '
      'sidebar', () {
    expect(using(r'\b(NavigationBar|BottomNavigationBar)\b'), [
      'lib/core/widgets/garage_bottom_nav.dart',
    ]);
  });

  test('and only the tab scaffold is given the bottom bar\'s slot', () {
    expect(using(r'\bbottomNavigationBar\s*:'), [
      'lib/core/widgets/garage_bottom_nav.dart',
    ]);
  });

  test('a Material date or time picker only in the date helpers', () {
    expect(using(r'\b(showDatePicker|showDateRangePicker|showTimePicker)\b'), [
      'lib/core/widgets/date_pickers.dart',
    ]);
  });

  test('a bottom sheet only in the adaptive helpers', () {
    expect(using(r'\b(showModalBottomSheet|showBottomSheet)\b'), [
      'lib/core/widgets/adaptive.dart',
    ]);
  });

  test('no ripple chosen by hand', () {
    expect(
      using(r'\b(InkRipple|InkSparkle|InkSplash)\.splashFactory\b'),
      isEmpty,
    );
  });

  test('a snackbar is placed by its host alone', () {
    expect(using(r'\bSnackBarBehavior\.'), [
      'lib/core/widgets/window_snackbars.dart',
    ]);
  });

  test('and no snackbar sizes or places itself', () {
    // A snackbar's own width or margin wins over the host's theme, and a
    // notice that set one would sit under the middle of a desk again.
    expect(argumentsOf('SnackBar', {'width', 'margin', 'behavior'}), isEmpty);
  });

  test('no navigation rail: the sidebar replaced it', () {
    expect(using(r'\bNavigationRail'), isEmpty);
  });
}
