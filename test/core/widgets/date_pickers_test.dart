import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/date_pickers.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../../support/browser.dart';
import '../../support/pump_screen.dart';

Future<void> openPicker(WidgetTester tester, Locale locale) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showGarageDatePicker(
              context: context,
              initialDate: DateTime(2026, 9, 4),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            ),
            child: const Text('pick'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('pick'));
  await tester.pumpAndSettle();
}

/// Whether the field to type a date in has the focus.
bool fieldFocused(WidgetTester tester) => tester
    .widget<EditableText>(
      find.descendant(
        of: find.byKey(const Key('typed-date')),
        matching: find.byType(EditableText),
      ),
    )
    .focusNode
    .hasFocus;

void main() {
  testWidgets('the week starts on Monday in English, like the planner', (
    tester,
  ) async {
    await openPicker(tester, const Locale('en'));

    // M is the leftmost weekday header; Sunday-first would put an S there.
    final m = tester.getTopLeft(find.text('M').first).dx;
    final firstS = tester.getTopLeft(find.text('S').first).dx;
    expect(m, lessThan(firstS));
  });

  testWidgets(
    'and keeps American formats, so a typed date means what it says',
    (tester) async {
      await openPicker(tester, const Locale('en'));
      // The header of the American picker: "Fri, Sep 4", not "Fri 4 Sept".
      expect(find.text('Fri, Sep 4'), findsOneWidget);
    },
  );

  group('the last date something already logged may carry', () {
    test('is today, because a fill-up next week is a typo', () {
      final now = DateTime(2026, 9, 4, 22, 30);
      expect(
        lastLoggableDate(DateTime(2026, 9, 1), now: now),
        DateTime(2026, 9, 4),
      );
    });

    test('the earliest is 2000, stretched by an older entry', () {
      // A classic car's service history, or a bad import, sits before 2000.
      // The picker asserts if its initial date falls outside its bounds.
      expect(firstLoggableDate(DateTime(2015, 3, 2)), DateTime(2000));
      final old = DateTime(1974, 6, 1);
      expect(firstLoggableDate(old), old);
    });

    test('stretches to an entry that is already dated ahead', () {
      // Imported data has carried future dates. Refusing to open the picker
      // on one would leave the household unable to correct it.
      final now = DateTime(2026, 9, 4, 22, 30);
      final ahead = DateTime(2026, 12, 1);
      expect(lastLoggableDate(ahead, now: now), ahead);
    });
  });

  group('on a desk', () {
    DateTime? picked;

    Future<void> openOnDesk(
      WidgetTester tester, {
      Locale? locale,
      Size surface = desktopSurface,
      double textScale = 1,
      String? helpText,
    }) async {
      picked = null;
      await pumpDesktop(
        tester,
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                picked = await showGarageDatePicker(
                  context: context,
                  initialDate: DateTime(2026, 9, 1),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2026, 9, 27),
                  helpText: helpText,
                );
              },
              child: const Text('pick'),
            ),
          ),
        ),
        locale: locale,
        surface: surface,
        textScale: textScale,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
    }

    String typed(WidgetTester tester) => tester
        .widget<TextField>(find.byKey(const Key('typed-date')))
        .controller!
        .text;

    /// The card's own scrolling, the nearest above the field.
    ScrollPosition cardScroll(WidgetTester tester) => tester
        .state<ScrollableState>(
          find
              .ancestor(
                of: find.byKey(const Key('typed-date')),
                matching: find.byType(Scrollable),
              )
              .first,
        )
        .position;

    testWidgets('is a field to type in and a calendar, not the dialog', (
      tester,
    ) async {
      await openOnDesk(tester);

      expect(find.byType(DatePickerDialog), findsNothing);
      expect(find.byKey(const Key('typed-date')), findsOneWidget);
      expect(find.byType(CalendarDatePicker), findsOneWidget);
    });

    testWidgets('its week starts on Monday in English too', (tester) async {
      await openOnDesk(tester);

      final m = tester.getTopLeft(find.text('M').first).dx;
      final firstS = tester.getTopLeft(find.text('S').first).dx;
      expect(m, lessThan(firstS));
    });

    testWidgets('takes a date typed in Croatian', (tester) async {
      await openOnDesk(tester, locale: const Locale('hr'));

      await tester.enterText(find.byKey(const Key('typed-date')), '19.9.2026.');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(picked, DateTime(2026, 9, 19));
    });

    testWidgets('says what it wants when the text is not a date', (
      tester,
    ) async {
      await openOnDesk(tester);

      await tester.enterText(find.byKey(const Key('typed-date')), '31/2/2026');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(picked, isNull);
      expect(find.textContaining('Type a date such as'), findsOneWidget);
    });

    testWidgets('and when it is after the last date allowed', (tester) async {
      await openOnDesk(tester);

      await tester.enterText(find.byKey(const Key('typed-date')), '10/1/2026');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(picked, isNull);
      expect(find.textContaining('Pick a date from'), findsOneWidget);
    });

    testWidgets('a day clicked in the calendar is picked', (tester) async {
      await openOnDesk(tester);

      await tester.tap(find.text('19'));
      await tester.pumpAndSettle();

      expect(picked, DateTime(2026, 9, 19));
    });

    testWidgets('a year chosen in the calendar is not a day picked', (
      tester,
    ) async {
      // Material's calendar reports a year chosen from its list of years as a
      // day, the one it had selected, in that year. The year already shown
      // reports one too, though no month changes.
      await openOnDesk(tester);

      await tester.tap(find.text('September 2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2026'));
      await tester.pumpAndSettle();

      expect(picked, isNull);
      expect(typed(tester), '9/1/2026');

      await tester.tap(find.text('September 2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2024'));
      await tester.pumpAndSettle();

      expect(picked, isNull);
      expect(typed(tester), '9/1/2024');

      await tester.tap(find.text('19'));
      await tester.pumpAndSettle();

      expect(picked, DateTime(2024, 9, 19));
    });

    testWidgets('on the web the field is ready to type in as it opens', (
      tester,
    ) async {
      asTheWeb(tester);
      await openOnDesk(tester);

      expect(fieldFocused(tester), isTrue);
      expect(tester.testTextInput.hasAnyClients, isTrue);
    });

    testWidgets('on the web what is not a date is asked again in the field', (
      tester,
    ) async {
      // Enter on a field with no editing-complete of its own lets the field
      // go before the date is read: refused, the typist was left with no
      // caret anywhere.
      asTheWeb(tester);
      await openOnDesk(tester);

      await tester.enterText(find.byKey(const Key('typed-date')), 'x');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.textContaining('Type a date such as'), findsOneWidget);
      expect(fieldFocused(tester), isTrue);
    });

    testWidgets('and so is a date outside the range', (tester) async {
      asTheWeb(tester);
      await openOnDesk(tester);

      await tester.enterText(find.byKey(const Key('typed-date')), '10/1/2026');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.textContaining('Pick a date from'), findsOneWidget);
      expect(fieldFocused(tester), isTrue);
    });

    testWidgets('the example it gives is the date it opened on', (
      tester,
    ) async {
      // In the reader's own order, and a date they might type: the last
      // date allowed can be next January, or 2100.
      await openOnDesk(tester);

      await tester.enterText(find.byKey(const Key('typed-date')), 'x');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Type a date such as 9/1/2026'), findsOneWidget);
    });

    testWidgets('a tablet held sideways keeps its keyboard off the calendar', (
      tester,
    ) async {
      // Wide, and not the web: a focused field would raise the on-screen
      // keyboard over the calendar under it.
      await openOnDesk(tester, surface: const Size(1280, 800));

      expect(find.byType(CalendarDatePicker), findsOneWidget);
      expect(fieldFocused(tester), isFalse);
      expect(tester.testTextInput.hasAnyClients, isFalse);
    });

    testWidgets(
      'the field is labelled above it, "Date" when nothing is asked',
      (tester) async {
        await openOnDesk(tester);

        final field = find.byKey(const Key('typed-date'));
        expect(find.text('Date'), findsOneWidget);
        expect(
          find.descendant(of: field, matching: find.text('Date')),
          findsNothing,
        );
        expect(
          tester.getRect(find.text('Date')).bottom,
          lessThanOrEqualTo(tester.getRect(field).top),
        );
      },
    );

    testWidgets('a question asked is the label, said once', (tester) async {
      await openOnDesk(tester, helpText: 'Until when?');

      final field = find.byKey(const Key('typed-date'));
      expect(find.text('Until when?'), findsOneWidget);
      expect(find.text('Date'), findsNothing);
      expect(
        tester.getRect(find.text('Until when?')).bottom,
        lessThanOrEqualTo(tester.getRect(field).top),
      );
    });

    testWidgets('a screen reader hears the label beside the field', (
      tester,
    ) async {
      // What LabeledField gives every form field in the app: the label is a
      // text node of its own beside the field's, which carries the date.
      //
      // Disposed in a finally, not a tear-down: the test checks for a live
      // handle as its body ends, before any tear-down runs, and a failing
      // expectation would otherwise skip a dispose made inline.
      final semantics = tester.ensureSemantics();
      try {
        await openOnDesk(tester);

        final label = tester.getSemantics(find.text('Date'));
        final field = tester.getSemantics(
          find.descendant(
            of: find.byKey(const Key('typed-date')),
            matching: find.byType(EditableText),
          ),
        );
        expect(label, isSemantics(label: 'Date', isTextField: false));
        expect(
          field,
          isSemantics(label: '', value: '9/1/2026', isTextField: true),
        );
        expect(label.parent, same(field.parent));
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('on the smallest tablet at large text the card scrolls', (
      tester,
    ) async {
      // 600 high, less the margins, holds less than a title, the field with
      // an error under it and the calendar at twice the text: the card
      // scrolls rather than run off the window or squeeze the calendar.
      await openOnDesk(
        tester,
        locale: const Locale('hr'),
        surface: const Size(1024, 600),
        textScale: 2,
        helpText: 'Početni datum',
      );
      await tester.enterText(find.byKey(const Key('typed-date')), 'x');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Upiši datum'), findsOneWidget);
      expect(cardScroll(tester).maxScrollExtent, greaterThan(0));
      final field = tester.getRect(find.byKey(const Key('typed-date')));
      expect(field.top, greaterThanOrEqualTo(0));
      expect(field.bottom, lessThanOrEqualTo(600));

      await tester.enterText(find.byKey(const Key('typed-date')), '19.9.2026.');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(picked, DateTime(2026, 9, 19));
    });

    testWidgets('at a desk\'s ordinary text the card does not scroll', (
      tester,
    ) async {
      await openOnDesk(tester);

      expect(cardScroll(tester).maxScrollExtent, 0);
    });
  });

  group('a range on a desk', () {
    DateTimeRange? range;

    Future<void> openRange(
      WidgetTester tester, {
      DateTimeRange? initialRange,
      DateTime? now,
    }) async {
      range = null;
      await pumpDesktop(
        tester,
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                range = await showGarageDateRange(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2027),
                  initialRange: initialRange,
                  now: now ?? DateTime(2026, 3, 10, 15, 30),
                );
              },
              child: const Text('range'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('range'));
      await tester.pumpAndSettle();
    }

    Future<void> type(WidgetTester tester, String date) async {
      await tester.enterText(find.byKey(const Key('typed-date')), date);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
    }

    DateTime? opensOn(WidgetTester tester) => tester
        .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
        .initialDate;

    testWidgets('with no range before it, the start opens on today', (
      tester,
    ) async {
      // Not on the last date allowed, which for statistics is next January.
      await openRange(tester);

      expect(find.text('Start date'), findsOneWidget);
      expect(opensOn(tester), DateTime(2026, 3, 10));
    });

    testWidgets('or on the last date allowed when today is past it', (
      tester,
    ) async {
      await openRange(tester, now: DateTime(2027, 6, 1));

      expect(opensOn(tester), DateTime(2027));
    });

    testWidgets('a start after the old end opens the end on that start', (
      tester,
    ) async {
      // The end's calendar starts at the start, and one opened on the old
      // end, before it, trips the calendar's own assertion.
      await openRange(
        tester,
        initialRange: DateTimeRange(
          start: DateTime(2026, 1, 5),
          end: DateTime(2026, 2, 20),
        ),
      );
      expect(opensOn(tester), DateTime(2026, 1, 5));

      await type(tester, '6/1/2026');

      expect(tester.takeException(), isNull);
      expect(find.text('End date'), findsOneWidget);
      expect(opensOn(tester), DateTime(2026, 6, 1));

      await type(tester, '6/30/2026');

      expect(
        range,
        DateTimeRange(start: DateTime(2026, 6, 1), end: DateTime(2026, 6, 30)),
      );
    });

    testWidgets('an end before the start is asked for again', (tester) async {
      await openRange(tester);
      await type(tester, '6/1/2026');
      await type(tester, '5/1/2026');

      expect(range, isNull);
      expect(find.textContaining('Pick a date from 6/1/2026'), findsOneWidget);
    });

    testWidgets('on the web, in the field it was typed in', (tester) async {
      asTheWeb(tester);
      await openRange(tester);
      await type(tester, '6/1/2026');
      await type(tester, '5/1/2026');

      expect(find.textContaining('Pick a date from 6/1/2026'), findsOneWidget);
      expect(fieldFocused(tester), isTrue);
    });
  });
}
