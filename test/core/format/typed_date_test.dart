import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/format/typed_date.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(initializeDateFormatting);

  final day = DateTime(2026, 9, 19);

  group('a date typed the way each language writes one', () {
    test('Croatian', () {
      expect(parseTypedDate('19.9.2026.', 'hr'), day);
      expect(parseTypedDate('19. 9. 2026.', 'hr'), day);
      expect(parseTypedDate('19.09.2026', 'hr'), day);
    });
    test('Italian', () {
      expect(parseTypedDate('19/9/2026', 'it'), day);
      expect(parseTypedDate('19/09/2026', 'it'), day);
    });
    test('English, month first as the app writes it', () {
      expect(parseTypedDate('9/19/2026', 'en'), day);
    });
    test('the ISO form in any of them', () {
      for (final locale in ['en', 'hr', 'it']) {
        expect(parseTypedDate('2026-09-19', locale), day, reason: locale);
      }
    });
    test('with spaces around it', () {
      expect(parseTypedDate('  19.9.2026. ', 'hr'), day);
    });
  });

  group('not a date', () {
    test('a day the month does not have', () {
      expect(parseTypedDate('31.2.2026.', 'hr'), isNull);
      expect(parseTypedDate('2026-02-31', 'hr'), isNull);
    });
    test('nor in the other two orders', () {
      // intl refuses these rather than rolling them over into March. A
      // version of it that rolled them over would save the third of March.
      expect(parseTypedDate('2/31/2026', 'en'), isNull);
      expect(parseTypedDate('31/2/2026', 'it'), isNull);
    });
    test('a two-digit year, which reads as the first century', () {
      expect(parseTypedDate('19.9.26.', 'hr'), isNull);
    });
    test('a year no calendar holds', () {
      // intl hands it to DateTime, which throws an ArgumentError rather than
      // the FormatException a typing mistake otherwise is.
      expect(parseTypedDate('9/19/300000', 'en'), isNull);
    });
    test('another language\'s order', () {
      expect(parseTypedDate('19/9/2026', 'en'), isNull);
    });
    test('nothing, or words', () {
      expect(parseTypedDate('', 'hr'), isNull);
      expect(parseTypedDate('jučer', 'hr'), isNull);
    });
  });

  test('what it writes, it reads back', () {
    for (final locale in ['en', 'hr', 'it']) {
      expect(
        parseTypedDate(formatTypedDate(day, locale), locale),
        day,
        reason: locale,
      );
    }
  });
}
