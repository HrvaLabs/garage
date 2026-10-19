import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/format/unit_format.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/page_scaffold.dart';
import 'package:garage/core/widgets/selectable_page.dart';
import 'package:garage/domain/fuel/fuel_economy.dart';
import 'package:garage/domain/stations/price_trend.dart';
import 'package:garage/domain/stats/spend_breakdown.dart';
import 'package:garage/domain/trips/route_trend.dart';
import 'package:garage/features/stations/widgets/price_trend_chart.dart';
import 'package:garage/features/stats/providers/stats_providers.dart';
import 'package:garage/features/stats/widgets/monthly_spend_bars.dart';
import 'package:garage/features/stats/widgets/odometer_chart.dart';
import 'package:garage/features/stats/widgets/spend_donut.dart';
import 'package:garage/features/trips/widgets/route_trend_chart.dart';
import 'package:garage/features/vehicles/widgets/economy_chart.dart';

import '../../support/browser.dart';
import '../../support/pump_screen.dart';
import '../../support/selection.dart';

/// [text] on screen inside a region whose text can be selected.
Finder _selectable(String text) =>
    find.ancestor(of: find.text(text), matching: find.byType(SelectableRegion));

/// A click on [clickOn], which puts the keyboard in the page as a click in a
/// browser does, then the whole page selected and copied.
Future<String?> _copyThePage(
  WidgetTester tester,
  FakeBrowser browser,
  String clickOn,
) async {
  await tester.tap(find.text(clickOn), kind: PointerDeviceKind.mouse);
  await tester.pump();
  await selectAllWithKeyboard(tester);
  await copyWithKeyboard(tester);
  return browser.copied;
}

const _page = GaragePageScaffold(title: 'Fuel', body: Text('52.3 L'));

final _format = UnitFormat(locale: 'en', preferences: metricPreferences);

EconomyPoint _economy(int odometerKm, double litersPer100Km) => EconomyPoint(
  entryId: 'f$odometerKm',
  date: DateTime.utc(2026, 5, 1),
  odometerKm: odometerKm,
  litersPer100Km: litersPer100Km,
  distanceKm: 500,
  volumeL: 30,
);

/// Each chart with the least it takes to be drawn, labels and all, and the
/// words it says that are the page's: a heading, a legend. Whatever else it
/// draws is a label on its plot.
final _charts = <(String, Widget, List<String>)>[
  (
    'the economy trend',
    EconomyChart(
      points: [_economy(50000, 6), _economy(50600, 7)],
      formatEconomy: (value) => '${value?.toStringAsFixed(1)} l/100km',
    ),
    const [],
  ),
  (
    'a spend donut',
    SpendDonut(
      title: 'By station',
      slices: const [SpendSlice(label: 'Petrol station', amount: 10)],
      format: _format,
    ),
    const ['BY STATION', 'Petrol station', '100%', '€10.00'],
  ),
  (
    'the monthly spend',
    MonthlySpendBars(
      months: [MonthSpend(month: DateTime.utc(2026, 1), fuel: 50, other: 20)],
      format: _format,
    ),
    const ['Fuel', 'Costs (without fuel)'],
  ),
  (
    'the odometer over time',
    OdometerChart(
      readingsPerVehicle: [
        [
          OdometerReading(
            date: DateTime.utc(2026, 1, 1),
            km: 50000,
            source: OdometerSource.fuel,
          ),
          OdometerReading(
            date: DateTime.utc(2026, 3, 1),
            km: 52000,
            source: OdometerSource.fuel,
          ),
        ],
      ],
      format: _format,
    ),
    const ['ODOMETER OVER TIME'],
  ),
  (
    'the national price trend',
    PriceTrendChart(
      series: [
        TrendPoint(
          date: DateTime.utc(2026, 8, 22),
          fuelTypeId: 1,
          avgPrice: 1.5,
        ),
        TrendPoint(
          date: DateTime.utc(2026, 8, 29),
          fuelTypeId: 1,
          avgPrice: 1.6,
        ),
      ],
      format: _format,
    ),
    const [],
  ),
  (
    'a route\'s trend',
    const RouteTrendChart(
      buckets: [
        RouteBucket(label: 'Week 12', median: 30, low: 25, high: 35, count: 5),
      ],
    ),
    const [],
  ),
];

/// [page] in a page between two sentences of its own, on a desk in a
/// browser, copied whole: what the clipboard then holds.
Future<String?> _copyAround(WidgetTester tester, Widget page) async {
  final browser = asTheWeb(tester);
  await pumpDesktop(
    tester,
    GaragePageScaffold(
      title: 'Statistics',
      body: ListView(
        children: [
          const Text('Above the chart'),
          page,
          const Text('Below the chart'),
        ],
      ),
    ),
    initialLocation: '/stats',
  );
  await tester.pumpAndSettle();
  return _copyThePage(tester, browser, 'Above the chart');
}

void main() {
  group('on a desk in a browser', () {
    testWidgets('a pushed page\'s text is selected and copied, and nothing '
        'of its bars', (tester) async {
      final browser = asTheWeb(tester);
      await pumpDesktop(tester, _page, initialLocation: '/vehicles/v1/fuel');
      await tester.pumpAndSettle();

      // Not "Fuel": the top bar names the page, and is not the page's text.
      expect(await _copyThePage(tester, browser, '52.3 L'), '52.3 L');
    });

    testWidgets('a tab\'s text is selected under its top bar', (tester) async {
      final browser = asTheWeb(tester);
      await pumpDesktop(
        tester,
        const GarageTabScaffold(
          current: GarageTab.timeline,
          title: 'Timeline',
          body: Text('Oil change'),
        ),
        initialLocation: '/timeline',
      );
      await tester.pumpAndSettle();

      expect(await _copyThePage(tester, browser, 'Oil change'), 'Oil change');
    });

    testWidgets('and under an app bar of its own', (tester) async {
      final browser = asTheWeb(tester);
      await pumpDesktop(
        tester,
        GarageTabScaffold(
          current: GarageTab.timeline,
          appBar: AppBar(title: const Text('Timeline')),
          body: const Text('Oil change'),
        ),
        initialLocation: '/timeline',
      );
      await tester.pumpAndSettle();

      expect(await _copyThePage(tester, browser, 'Oil change'), 'Oil change');
    });

    // The page takes the keys from a click on its text, so Ctrl+A selects
    // it. Tab passes over it, as over a web page: stopping there, it showed
    // nothing on its way from the top bar to the page's first control.
    testWidgets('Tab passes over the page to its first control, and back', (
      tester,
    ) async {
      asTheWeb(tester);
      final before = FocusNode(debugLabel: 'before');
      final inside = FocusNode(debugLabel: 'inside');
      addTearDown(before.dispose);
      addTearDown(inside.dispose);
      await pumpDesktop(
        tester,
        GaragePageScaffold(
          title: 'Fuel',
          actions: [
            IconButton(
              focusNode: before,
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
          ],
          body: Column(
            children: [
              const Text('52.3 L'),
              TextButton(
                focusNode: inside,
                onPressed: () {},
                child: const Text('Open'),
              ),
            ],
          ),
        ),
        initialLocation: '/vehicles/v1/fuel',
      );
      await tester.pumpAndSettle();
      before.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(FocusManager.instance.primaryFocus, inside);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
      await tester.pump();
      expect(FocusManager.instance.primaryFocus, before);
    });
  });

  testWidgets('a tablet held sideways keeps its long press for the row', (
    tester,
  ) async {
    await pumpDesktop(tester, _page, initialLocation: '/vehicles/v1/fuel');
    await tester.pumpAndSettle();

    expect(_selectable('52.3 L'), findsNothing);
  });

  testWidgets('a phone keeps it too, in a browser as well', (tester) async {
    asTheWeb(tester);
    await pumpScreen(tester, _page, initialLocation: '/vehicles/v1/fuel');
    await tester.pumpAndSettle();

    expect(_selectable('52.3 L'), findsNothing);
  });

  testWidgets('a page outside the scaffolds holds the same line', (
    tester,
  ) async {
    asTheWeb(tester);
    const page = Scaffold(body: SelectablePage(child: Text('52.3 L')));

    await pumpScreen(tester, page, initialLocation: '/quick');
    await tester.pumpAndSettle();
    expect(_selectable('52.3 L'), findsNothing);

    await pumpDesktop(tester, page, initialLocation: '/quick');
    await tester.pumpAndSettle();
    expect(_selectable('52.3 L'), findsOneWidget);
  });

  // A chart's labels are places on a drawing. Selected with the page around
  // it, they were copied as a run of stray numbers between its sentences. Its
  // heading, its legend and what it says in place of a plot are the page's.
  group('a page copied whole', () {
    for (final (name, chart, words) in _charts) {
      testWidgets('leaves out the labels of $name and keeps its words', (
        tester,
      ) async {
        final copied = await _copyAround(tester, chart);
        final drawn = [
          for (final text in tester.widgetList<RichText>(
            find.descendant(
              of: find.byWidget(chart),
              matching: find.byType(RichText),
            ),
          ))
            if (text.text.toPlainText().trim() case final shown
                when shown.isNotEmpty)
              shown,
        ];
        final labels = [
          for (final shown in drawn)
            if (!words.contains(shown)) shown,
        ];
        expect(drawn, containsAll(words), reason: 'the words are on screen');
        if (chart is SpendDonut) {
          expect(
            labels,
            isEmpty,
            reason:
                'a PieChart draws no text of its own, so for the donut the '
                'half about labels has nothing to leave out',
          );
        } else {
          expect(
            labels,
            isNotEmpty,
            reason: 'drawn with its labels, or leaving them out proves nothing',
          );
        }

        expect(copied, contains('Above the chart'));
        expect(copied, contains('Below the chart'));
        for (final word in words) {
          expect(copied, contains(word), reason: '"$word" is the page\'s');
        }
        // Checked as substrings of the whole copy, and a label can be as
        // short as "0": the page's own sentences carry no digits.
        for (final label in labels) {
          expect(copied, isNot(contains(label)), reason: '"$label" copied');
        }
      });
    }

    testWidgets('keeps the economy trend\'s guidance', (tester) async {
      final copied = await _copyAround(
        tester,
        EconomyChart(
          points: [_economy(50000, 6)],
          formatEconomy: (value) => '${value?.toStringAsFixed(1)} l/100km',
        ),
      );

      expect(copied, contains('Log more full-tank fills to see the trend'));
    });
  });
}
