import 'package:intl/intl.dart';

/// A date as somebody types it, in their language's order: `19.9.2026.` in
/// Croatian, `19/9/2026` in Italian, `9/19/2026` in English, and
/// `2026-09-19` in any of them.
///
/// Null for anything that is not a real day, `31.2.2026.` included, and for
/// a year before 1900, which is what a two-digit year parses to: better
/// asked again than saved as the year 26.
DateTime? parseTypedDate(String input, String locale) {
  final text = input.trim();
  if (text.isEmpty) {
    return null;
  }
  DateTime? parsed;
  final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
  if (iso != null) {
    final year = int.parse(iso[1]!);
    final month = int.parse(iso[2]!);
    final day = int.parse(iso[3]!);
    final candidate = DateTime(year, month, day);
    parsed = candidate.month == month && candidate.day == day
        ? candidate
        : null;
  } else {
    try {
      // Loose, so a Croatian date reads with or without its spaces and its
      // last full stop. It still refuses a day the month does not have
      // rather than rolling it over into the next month.
      parsed = DateFormat.yMd(locale).parseLoose(text);
    } on FormatException {
      return null;
    } on ArgumentError {
      // A year no DateTime holds, 300000 say: intl hands it to the
      // constructor, which refuses it with an error, not a FormatException.
      return null;
    }
  }
  if (parsed == null || parsed.year < 1900) {
    return null;
  }
  return DateTime(parsed.year, parsed.month, parsed.day);
}

/// [date] as [parseTypedDate] reads it back: the language's own numeric form.
String formatTypedDate(DateTime date, String locale) =>
    DateFormat.yMd(locale).format(date);
