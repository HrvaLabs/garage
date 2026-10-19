import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../features/company/providers/company_providers.dart';
import '../../features/dashboard/widgets/quick_add_button.dart';
import 'adaptive.dart';
import 'garage_sidebar.dart';
import 'page_header.dart';
import 'stale_reads_banner.dart';

/// The app's primary sections. Shared so every top-level screen presents the
/// same four-tab navigation and a consistent current-tab highlight.
enum GarageTab { dashboard, timeline, vehicles, planner, more }

/// Where each tab lives. Public because the router has to agree with it: tabs
/// are peers and cross-fade between one another, and a tab route registered
/// like a pushed detail page instead slides in over its own navigation bar.
const tabRoutes = {
  GarageTab.dashboard: '/',
  GarageTab.timeline: '/timeline',
  GarageTab.vehicles: '/vehicles',
  GarageTab.planner: '/planner',
  GarageTab.more: '/more',
};

class _Destination {
  const _Destination(this.tab, this.icon, this.selectedIcon, this.label);

  final GarageTab tab;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// [driver] names the cars tab for the cars handed to a driver, as the list
/// it opens is titled "My cars" for them.
List<_Destination> _destinations(
  AppLocalizations l10n, {
  required bool driver,
}) => [
  _Destination(
    GarageTab.dashboard,
    Icons.dashboard_outlined,
    Icons.dashboard,
    l10n.dashboardTitle,
  ),
  _Destination(
    GarageTab.timeline,
    Icons.view_timeline_outlined,
    Icons.view_timeline,
    l10n.timelineTitle,
  ),
  _Destination(
    GarageTab.vehicles,
    Icons.directions_car_outlined,
    Icons.directions_car,
    driver ? l10n.companyDriverCarsTab : l10n.vehiclesTitle,
  ),
  _Destination(
    GarageTab.planner,
    Icons.event_note_outlined,
    Icons.event_note,
    l10n.plannerTitle,
  ),
  // "More", not "Settings". Nobody looks under Settings for the people they
  // share a car with, and that is where the garage, the statistics, the trip
  // log, the stations and the calculator all lived.
  _Destination(
    GarageTab.more,
    Icons.more_horiz_outlined,
    Icons.more_horiz,
    l10n.settingsMore,
  ),
];

void _goTo(BuildContext context, GarageTab current, int index) {
  final tab = GarageTab.values[index];
  if (tab != current) {
    context.go(tabRoutes[tab]!);
  }
}

/// Scaffold for the four top-level tab screens. Adapts the navigation to the
/// window: bottom bar on phones, [GarageSidebar] beside the content pane on
/// wide windows, where a titled page's top bar spans the pane above a
/// centred content column.
class GarageTabScaffold extends StatelessWidget {
  const GarageTabScaffold({
    super.key,
    required this.current,
    required this.body,
    this.appBar,
    this.title,
    this.actions = const [],
    this.floatingActionButton,
    this.contentWidth = ContentWidth.reading,
  });

  final GarageTab current;
  final Widget body;

  /// How much of a desktop window this screen's content should use. Reading
  /// width suits a form; a dashboard or a list wants the room.
  final ContentWidth contentWidth;

  /// The page's name. Given this, the scaffold titles the page itself: an app
  /// bar on a phone, and on a desktop window a top bar across the content
  /// pane ([PageHeader]), beside the sidebar, where a bar above it would be
  /// phone chrome. Screens still passing [appBar] keep their old presentation
  /// on both.
  final String? title;

  /// Shown beside the title, in the app bar or the page header as appropriate.
  final List<Widget> actions;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  PreferredSizeWidget? _titleBar() =>
      title == null ? null : AppBar(title: Text(title!), actions: actions);

  @override
  Widget build(BuildContext context) {
    // Above the content on every screen, so a page that reads three lists
    // says once that they are copies rather than each list saying nothing.
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StaleReadsBanner(),
        Expanded(child: body),
      ],
    );
    final wide = GarageBreakpoints.isWide(context);
    if (!wide) {
      return Scaffold(
        appBar: appBar ?? _titleBar(),
        body: content,
        bottomNavigationBar: GarageBottomNav(current: current),
        floatingActionButton: floatingActionButton,
      );
    }

    return Scaffold(
      appBar: title == null ? appBar : null,
      body: Row(
        children: [
          const GarageSidebar(),
          const VerticalDivider(width: 1),
          Expanded(
            // The content pane is a scaffold of its own, so the floating
            // button belongs to it rather than to the window. Snackbars are
            // sized by WindowSnackBars at the root: a messenger here would
            // never see one raised from a sheet.
            child: Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: floatingActionButton,
              // The page names itself in a bar across the pane, rather than
              // in one above the sidebar. A tab is a section: no crumbs.
              body: title == null
                  ? AdaptiveContent(width: contentWidth, child: content)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PageHeader(
                          title: title!,
                          actions: actions,
                          trailing: const [QuickAddButton()],
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: AdaptiveContent(
                            width: contentWidth,
                            child: content,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class GarageBottomNav extends ConsumerWidget {
  const GarageBottomNav({required this.current, super.key});

  final GarageTab current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: GarageTab.values.indexOf(current),
      onDestinationSelected: (index) => _goTo(context, current, index),
      destinations: [
        for (final destination in _destinations(
          l10n,
          driver: ref.watch(isDriverProvider),
        ))
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: destination.label,
            // The label is already under the icon; on web the default
            // tooltip repeats it and sticks to the bar under the pointer.
            tooltip: '',
          ),
      ],
    );
  }
}
