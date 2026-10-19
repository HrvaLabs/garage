import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/foundation.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../format/typed_date.dart';
import '../theme/garage_theme.dart';
import '../theme/garage_tokens.dart';
import 'adaptive.dart';
import 'anchored_popover.dart';
import 'labeled_field.dart';

/// The latest date a record of something that has already happened may carry.
///
/// Today, not 2100: a fill-up or a service dated next week is a typo, and the
/// picker is where it is cheapest to catch. [current] widens the bound when
/// the entry is already dated ahead — imported data has carried such dates,
/// and a picker that will not open on one leaves it uncorrectable.
DateTime lastLoggableDate(DateTime current, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final endOfToday = DateTime(today.year, today.month, today.day);
  return current.isAfter(endOfToday) ? current : endOfToday;
}

/// The earliest date a record may carry: the year 2000, or the entry's own
/// date when it is older still.
///
/// The same argument as [lastLoggableDate] in the other direction — a picker
/// whose bounds exclude the date it is opening on trips the framework's own
/// assertion, and a classic car's service history predates the floor.
DateTime firstLoggableDate(DateTime current) {
  final floor = DateTime(2000);
  return current.isBefore(floor) ? current : floor;
}

/// The app's date picker, with the week starting on Monday in English as it
/// does on the planner calendar.
///
/// On a phone it is Material's dialog. Only the first weekday changes: asking
/// for British English would have done that too, and also switched the
/// picker's typed dates to day-first while the rest of the English interface
/// is month-first, so "09/04/2026" typed the way the app shows dates would
/// have saved 9 April.
///
/// On a wide window it is a popover hung from what asked for it
/// ([showAnchoredPopover]): a field that reads a date typed in the reader's
/// own order ([parseTypedDate]), and the calendar under it. Enter takes what
/// is typed and a click takes the day; Escape or a click outside takes
/// nothing. Material's dialog is a phone's, a calendar in the middle of the
/// monitor and a pen icon to reach the typing, and a desk types (decision
/// 199). On the web the field has the focus as it opens
/// ([GarageDatePicker.focusesField]).
Future<DateTime?> showGarageDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,

  /// Replaces "Select date" on a phone and the field's "Date" on a desk
  /// when the question is a particular one: a loan asks "until when?".
  String? helpText,
}) {
  final english = Localizations.localeOf(context).languageCode == 'en';
  if (GarageBreakpoints.isWide(context)) {
    Widget popover(BuildContext context) => _DatePopover(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
    );
    return showAnchoredPopover<DateTime>(
      context,
      maxWidth: 360,
      builder: english
          ? (context) => Localizations.override(
              context: context,
              delegates: const [_MondayFirstEnglishDelegate()],
              child: Builder(builder: popover),
            )
          : popover,
    );
  }
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: helpText,
    builder: english
        ? (context, child) => Localizations.override(
            context: context,
            delegates: const [_MondayFirstEnglishDelegate()],
            child: child!,
          )
        : null,
  );
}

/// A start and an end date: Material's range dialog on a phone, and on a wide
/// window the date popover twice, the end's calendar beginning at the start.
///
/// The start opens on the range before it, or else on today ([now] when
/// given) rather than on the last date allowed, which for statistics is next
/// January. The end opens on the old end, or on the start when that is
/// later: a calendar opened before its first date trips the framework's own
/// assertion.
Future<DateTimeRange?> showGarageDateRange({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialRange,
  DateTime? now,
}) async {
  if (!GarageBreakpoints.isWide(context)) {
    return showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialRange,
    );
  }
  DateTime within(DateTime date, DateTime first) =>
      date.isBefore(first) ? first : (date.isAfter(lastDate) ? lastDate : date);
  final today = now ?? DateTime.now();
  final l10n = AppLocalizations.of(context)!;
  final start = await showGarageDatePicker(
    context: context,
    initialDate: within(
      initialRange?.start ?? DateTime(today.year, today.month, today.day),
      firstDate,
    ),
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: l10n.dateRangeStart,
  );
  if (start == null || !context.mounted) {
    return null;
  }
  final end = await showGarageDatePicker(
    context: context,
    initialDate: within(initialRange?.end ?? start, start),
    firstDate: start,
    lastDate: lastDate,
    helpText: l10n.dateRangeEnd,
  );
  return end == null ? null : DateTimeRange(start: start, end: end);
}

/// What [showGarageDatePicker] does on the web alone, which a test turns on.
abstract final class GarageDatePicker {
  /// Whether the field to type a date in takes the focus as the popover on a
  /// wide window opens: on the web, and in a test that asks. A tablet held
  /// sideways is wide too, and there a focused field would put the on-screen
  /// keyboard over the calendar under it.
  @visibleForTesting
  static bool focusesField = kIsWeb;
}

class _MondayFirstEnglishDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _MondayFirstEnglishDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    const name = 'en';
    // Synchronous, like the framework's own delegate: an async load gives
    // the dialog a blank first frame.
    return SynchronousFuture(
      _MondayFirstEnglish(
        fullYearFormat: intl.DateFormat.y(name),
        compactDateFormat: intl.DateFormat.yMd(name),
        shortDateFormat: intl.DateFormat.yMMMd(name),
        mediumDateFormat: intl.DateFormat.MMMEd(name),
        longDateFormat: intl.DateFormat.yMMMMEEEEd(name),
        yearMonthFormat: intl.DateFormat.yMMMM(name),
        shortMonthDayFormat: intl.DateFormat.MMMd(name),
        decimalFormat: intl.NumberFormat.decimalPattern(name),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', name),
      ),
    );
  }

  @override
  bool shouldReload(_MondayFirstEnglishDelegate old) => false;
}

/// American English in every string and format, Monday first in the grid.
class _MondayFirstEnglish extends MaterialLocalizationEn {
  const _MondayFirstEnglish({
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

  @override
  int get firstDayOfWeekIndex => 1;
}

/// A date typed in the reader's own order, or clicked in the calendar under
/// it. Enter takes what is typed; a click takes the day.
class _DatePopover extends StatefulWidget {
  const _DatePopover({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.helpText,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? helpText;

  @override
  State<_DatePopover> createState() => _DatePopoverState();
}

class _DatePopoverState extends State<_DatePopover> {
  TextEditingController? _text;
  String? _error;

  String get _locale => Localizations.localeOf(context).languageCode;

  static DateTime _day(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _text ??= TextEditingController(
      text: formatTypedDate(widget.initialDate, _locale),
    );
  }

  @override
  void dispose() {
    _text?.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final typed = parseTypedDate(_text!.text, _locale);
    if (typed == null) {
      setState(
        () => _error = l10n.dateTypeHint(
          formatTypedDate(widget.initialDate, _locale),
        ),
      );
      return;
    }
    if (typed.isBefore(_day(widget.firstDate)) ||
        typed.isAfter(_day(widget.lastDate))) {
      setState(
        () => _error = l10n.dateOutOfRange(
          formatTypedDate(widget.firstDate, _locale),
          formatTypedDate(widget.lastDate, _locale),
        ),
      );
      return;
    }
    Navigator.of(context).pop(typed);
  }

  void _calendarChanged(DateTime date) {
    // Material's calendar reports a year chosen from its list of years here
    // too, as a day: the one it had selected, moved to that year. That is a
    // year to look at, not a day picked, so the field follows it and the
    // popover stays open for the day.
    if (_showingYears()) {
      _text!.text = formatTypedDate(date, _locale);
      setState(() => _error = null);
      return;
    }
    Navigator.of(context).pop(_day(date));
  }

  /// Whether the calendar's list of years is on show. It reports a year
  /// before it goes back to the days, so the list is still there to find,
  /// and a year the same as the one on show changes no month to tell by.
  bool _showingYears() {
    var found = false;
    void visit(Element element) {
      if (element.widget is YearPicker) {
        found = true;
      } else if (!found) {
        element.visitChildren(visit);
      }
    }

    context.visitChildElements(visit);
    return found;
  }

  @override
  Widget build(BuildContext context) {
    // The popover holds the card inside the window, and on the smallest
    // tablet held sideways, at large text, the label, the field with an
    // error and the calendar are taller than that: the card scrolls then,
    // rather than run off the window or squeeze the calendar, and only then.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(GarageTokens.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The question, when one is asked, is the label: one line above
          // the field rather than a title over a label.
          LabeledField(
            label:
                widget.helpText ?? AppLocalizations.of(context)!.dateFieldLabel,
            child: TextField(
              key: const Key('typed-date'),
              controller: _text,
              autofocus: GarageDatePicker.focusesField,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
              style: GarageTheme.numericField(context),
              decoration: InputDecoration(errorText: _error, errorMaxLines: 2),
              // Not onSubmitted: with no editing-complete of its own, Enter
              // lets the field go before the date is read, and a date asked
              // for again would find no caret to type it with.
              onEditingComplete: _submit,
            ),
          ),
          const SizedBox(height: GarageTokens.space2),
          CalendarDatePicker(
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            onDateChanged: _calendarChanged,
          ),
        ],
      ),
    );
  }
}
