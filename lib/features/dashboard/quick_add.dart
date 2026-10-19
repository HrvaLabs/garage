import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../../core/theme/garage_theme.dart';
import '../../core/theme/garage_tokens.dart';
import '../../core/widgets/adaptive.dart';
import '../company/providers/company_providers.dart';
import '../costs/widgets/cost_entry_sheet.dart';
import '../fuel/widgets/fuel_entry_sheet.dart';
import '../income/widgets/income_entry_sheet.dart';
import '../maintenance/widgets/reminder_rule_sheet.dart';
import '../maintenance/widgets/service_entry_sheet.dart';
import '../odometer/widgets/odometer_entry_sheet.dart';
import '../trips/widgets/drive_card.dart';
import '../trips/widgets/trip_entry_sheet.dart';
import '../vehicles/providers/vehicle_providers.dart';
import '../vehicles/widgets/vehicle_picker.dart';

/// Offers everything a household records, and asks which car only when there
/// is more than one: a single-car household should never be made to answer a
/// question with one possible answer.
///
/// Ordered by how often it is used, not by how the schema is arranged: fuel is
/// weekly, a service is a few times a year, and selling the car happens once.
Future<void> showQuickAdd(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  // Active cars only, and this is the whole reason to say so: an archived
  // vehicle has left the household, so it is not something anybody is filling
  // up. Reading the full list made the + button ask "which car?" in a garage
  // with one car and one sold one, and offered the sold one as an answer —
  // while the shortcut on the dashboard's own vehicle rows had always read
  // the active list. The buttons that open this sheet read the active list
  // too, so an all-archived garage never gets here.
  final vehicles = await ref.read(vehiclesProvider.future);
  if (vehicles.isEmpty || !context.mounted) {
    return;
  }
  // A rule and money in are the garage's, not a driver's to log: both
  // inserts are refused, so neither row is offered.
  final driver = ref.read(isDriverProvider);

  final action = await showAdaptiveChoice<QuickAction>(
    context,
    (context) => SafeArea(
      child: Padding(
        // Room under the last row: "More", and Income once it is open, sat
        // on the edge of the screen.
        padding: const EdgeInsets.only(bottom: GarageTokens.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The three things that cost money, as tiles: they are what the
            // button is pressed for nine times in ten. Seven equal rows made
            // someone read past Income and Add reminder to find Fuel up.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                GarageTokens.space4,
                GarageTokens.space4,
                GarageTokens.space4,
                GarageTokens.space2,
              ),
              child: Row(
                spacing: GarageTokens.space3,
                children: [
                  _QuickTile(
                    icon: Icons.local_gas_station_outlined,
                    label: l10n.quickAddFuel,
                    onTap: () => Navigator.of(context).pop(QuickAction.fuel),
                  ),
                  _QuickTile(
                    icon: Icons.build_outlined,
                    label: l10n.quickAddService,
                    onTap: () => Navigator.of(context).pop(QuickAction.service),
                  ),
                  _QuickTile(
                    icon: Icons.receipt_long_outlined,
                    label: l10n.quickAddCost,
                    onTap: () => Navigator.of(context).pop(QuickAction.cost),
                  ),
                ],
              ),
            ),
            ExpansionTile(
              key: const Key('quick-add-more'),
              title: Text(l10n.quickAddMore),
              shape: const Border(),
              collapsedShape: const Border(),
              children: [
                // Then the ones with nothing to pay: a reading and a trip are what
                // you log when there was no transaction to log.
                ListTile(
                  leading: const Icon(Icons.speed_outlined),
                  title: Text(l10n.quickAddOdometer),
                  onTap: () => Navigator.of(context).pop(QuickAction.odometer),
                ),
                // Starting a drive is the act done getting into the car,
                // and it was five taps away under More (decision 156).
                ListTile(
                  leading: const Icon(Icons.play_arrow_outlined),
                  title: Text(l10n.tripDriveStart),
                  onTap: () => Navigator.of(context).pop(QuickAction.drive),
                ),
                ListTile(
                  leading: const Icon(Icons.route_outlined),
                  title: Text(l10n.tripAdd),
                  onTap: () => Navigator.of(context).pop(QuickAction.trip),
                ),
                // The interval, which reminders and the whole planner are built on,
                // was six taps deep and absent from here entirely — so the one thing
                // that makes the app work was the hardest thing in it to reach.
                if (!driver) ...[
                  ListTile(
                    leading: const Icon(Icons.event_repeat_outlined),
                    title: Text(l10n.quickAddInterval),
                    onTap: () =>
                        Navigator.of(context).pop(QuickAction.interval),
                  ),
                  ListTile(
                    leading: const Icon(Icons.savings_outlined),
                    title: Text(l10n.quickAddIncome),
                    onTap: () => Navigator.of(context).pop(QuickAction.income),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
  if (action == null || !context.mounted) {
    return;
  }

  var vehicleId = vehicles.first.id;
  if (vehicles.length > 1) {
    final picked = await showVehiclePicker(context, vehicles);
    if (picked == null || !context.mounted) {
      return;
    }
    vehicleId = picked;
  }

  await runQuickAction(context, ref, action, vehicleId);
}

/// Opens the sheet for [action] against [vehicleId].
///
/// Split out of the quick-add flow because the empty-state card needs the same
/// two of these without the sheet that asks which action and which vehicle.
Future<void> runQuickAction(
  BuildContext context,
  WidgetRef ref,
  QuickAction action,
  String vehicleId,
) async {
  switch (action) {
    case QuickAction.fuel:
      await showFuelEntrySheet(context, vehicleId);
    case QuickAction.service:
      await showServiceEntrySheet(context, vehicleId);
    case QuickAction.cost:
      await showCostEntrySheet(context, vehicleId);
    case QuickAction.odometer:
      await showOdometerEntrySheet(context, vehicleId);
    case QuickAction.drive:
      await showStartDriveSheet(context, ref, vehicleId);
    case QuickAction.trip:
      await showTripEntrySheet(context, vehicleId);
    case QuickAction.income:
      await showIncomeEntrySheet(context, vehicleId);
    case QuickAction.interval:
      await showReminderRuleSheet(context, vehicleId);
  }
}

enum QuickAction {
  fuel,
  service,
  cost,
  odometer,
  drive,
  trip,
  income,
  interval,
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // A desk's theme draws a card as a row with a rule under it, and three of
    // those side by side read as underlined labels, a tab strip, until one
    // was hovered. On a desk they keep the outline a card has on a phone;
    // a phone's are the theme's cards, as they were.
    final wide = GarageBreakpoints.isWide(context);
    return Expanded(
      child: Card(
        shape: wide
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GarageTokens.radiusMd),
                side: BorderSide(color: context.tokens.border),
              )
            : null,
        // So the hover fills the tile to its rounded corners and no further.
        clipBehavior: wide ? Clip.antiAlias : null,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: GarageTokens.space4,
              horizontal: GarageTokens.space2,
            ),
            child: Column(
              children: [
                Icon(icon, color: context.tokens.accent),
                const SizedBox(height: GarageTokens.space2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
