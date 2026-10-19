import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../../features/company/providers/company_providers.dart';
import '../../features/dashboard/widgets/quick_add_button.dart';
import '../../features/vehicles/providers/vehicle_providers.dart';
import '../router/page_location.dart';
import 'adaptive.dart';
import 'anchored_popover.dart';
import 'desktop_shortcuts.dart';
import 'garage_bottom_nav.dart';
import 'garage_sidebar.dart';
import 'page_header.dart';
import 'page_title.dart';
import 'primary_action.dart';
import 'selectable_page.dart';
import 'stale_reads_banner.dart';

/// Scaffold for a screen that was pushed onto another, the counterpart to
/// [GarageTabScaffold] for the top-level destinations.
///
/// Adapts the same way: an app bar on a phone, a top bar across the content
/// pane on a desktop window ([PageHeader]), which also says where the page
/// sits. Unlike a tab, a pushed page keeps a way back, because here back goes
/// somewhere the user actually came from.
class GaragePageScaffold extends ConsumerWidget {
  const GaragePageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.primaryAction,
    this.bottom,
    this.contentWidth = ContentWidth.reading,
    this.showNavigation = true,
    this.crumbs,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  /// The page's main act: floating on a phone, in the top bar on a desk
  /// (decision 198). A page without navigation keeps the phone's
  /// presentation at every width, its floating button included.
  final PrimaryAction? primaryAction;

  /// A tab bar or similar, shown under the title in both presentations.
  final PreferredSizeWidget? bottom;

  /// How much of a desktop window the content should use. Reading width by
  /// default: most pushed screens are forms or two-ended list rows, where the
  /// extra space only pushes a row's two halves apart.
  final ContentWidth contentWidth;

  /// Whether the desktop sidebar belongs on this page. False for a screen
  /// reachable before signing in: every destination in that sidebar bounces
  /// a visitor to the sign-in form, which reads as the app being broken
  /// rather than as a gate.
  final bool showNavigation;

  /// Where the page sits, in its top bar on a desktop window. Null reads them
  /// from the page's address ([sectionCrumbs]); an empty list means none.
  final List<Crumb>? crumbs;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      PageTitle(title: title, child: _page(context, ref));

  Widget _page(BuildContext context, WidgetRef ref) {
    // Above the content on every screen, so a page that reads three lists
    // says once that they are copies rather than each list saying nothing.
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StaleReadsBanner(),
        Expanded(child: body),
      ],
    );
    if (!GarageBreakpoints.isWide(context) || !showNavigation) {
      return Scaffold(
        appBar: AppBar(title: Text(title), actions: actions, bottom: bottom),
        body: content,
        floatingActionButton: primaryAction?.floating(),
      );
    }

    final location = pageLocation(context);
    final car = crumbCarId(location);

    // The sidebar stays. These pages are pushed, but a desktop window that
    // loses its navigation the moment you open Statistics leaves the browser's
    // back button as the only way out. The link the page sits under is lit.
    return Scaffold(
      body: DesktopShortcuts(
        child: Row(
          children: [
            const GarageSidebar(),
            const VerticalDivider(width: 1),
            Expanded(
              child: PopoverPane(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The pane's whole width: a top bar, not a heading held to
                    // the text column.
                    PageHeader(
                      title: title,
                      crumbs:
                          crumbs ??
                          sectionCrumbs(
                            AppLocalizations.of(context)!,
                            location,
                            carName: car == null
                                ? null
                                : ref
                                      .watch(vehicleProvider(car))
                                      .value
                                      ?.nickname,
                            driver: ref.watch(isDriverProvider),
                          ),
                      actions: actions,
                      // The page's own act, then what every page offers.
                      trailing: [
                        if (primaryAction case final action?
                            when action.showOnWide)
                          action.toolbar(),
                        // Keyed, so it stays itself as an act joins it.
                        const QuickAddButton(key: ValueKey(QuickAddButton)),
                      ],
                      // Only offered when there is something to go back to; a
                      // page opened directly by URL on the web has an empty
                      // stack.
                      onBack: Navigator.of(context).canPop()
                          ? () => Navigator.of(context).maybePop()
                          : null,
                    ),
                    // A tab strip under the bar draws its own rule.
                    if (bottom == null) const Divider(height: 1),
                    // Outside the column on purpose. A tab strip belongs to the
                    // surface it switches, so it runs the width of the pane
                    // along with its divider — the same edge-to-edge strip a
                    // phone gets from the app bar. Held to the text column it
                    // read as a control floating mid-page, above a rule that
                    // stopped short of both sides.
                    ?bottom,
                    Expanded(
                      child: AdaptiveContent(
                        width: contentWidth,
                        child: SelectablePage(child: content),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
