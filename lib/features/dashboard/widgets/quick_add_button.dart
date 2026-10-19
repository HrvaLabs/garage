import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../../../core/theme/garage_theme.dart';
import '../../vehicles/providers/vehicle_providers.dart';
import '../quick_add.dart';

/// The dashboard's +, in the top bar of every page on a desk.
///
/// Hidden while the garage has no car: there is nothing to log against, and
/// the dashboard's empty state is where adding one is explained. Outlined, the
/// app's secondary button: a page's own act beside it is the filled one, and
/// in the same fill the two would read as one offer made twice.
class QuickAddButton extends ConsumerWidget {
  const QuickAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(vehiclesProvider).value?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return OutlinedButton.icon(
      key: const Key('top-bar-quick-add'),
      style: GarageTheme.toolbarButton,
      onPressed: () => showQuickAdd(context, ref),
      icon: const Icon(Icons.add),
      label: Text(AppLocalizations.of(context)!.quickAddNew),
    );
  }
}
