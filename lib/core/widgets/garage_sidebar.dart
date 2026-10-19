import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_providers.dart';
import '../../features/company/providers/company_providers.dart';
import '../../features/household/providers/household_providers.dart';
import '../router/page_location.dart';
import '../theme/garage_theme.dart';
import '../theme/garage_tokens.dart';
import 'adaptive.dart';
import 'garage_bottom_nav.dart';
import 'secondary_destinations.dart';

/// A place the sidebar leads to.
class SidebarLink {
  const SidebarLink(this.label, this.icon, this.route, {this.tab = false});

  final String label;
  final IconData icon;
  final String route;

  /// A tab is gone to, replacing the page. Anything else is pushed, so the
  /// page's own back and the browser's return to where the reader was,
  /// unless the page sits under it: then the link leads up, and is gone to.
  final bool tab;
}

/// The link a page at [location] sits under: the one whose route is the
/// longest whole-segment prefix of it. `/` holds only itself, so an address
/// no link holds lights nothing rather than the dashboard.
SidebarLink? currentLink(List<SidebarLink> links, String location) {
  SidebarLink? best;
  for (final link in links) {
    final route = link.route;
    final holds = route == '/'
        ? location == '/'
        : location == route || location.startsWith('$route/');
    if (holds && (best == null || route.length > best.route.length)) {
      best = link;
    }
  }
  return best;
}

/// The desktop sidebar (decision 198).
///
/// Labelled, 240 pixels wide, from [GarageBreakpoints.desktop]; icons named
/// in tooltips between [GarageBreakpoints.wide] and that. Five primaries —
/// the four tabs and the garage's people — then the tools, then what More
/// holds on a phone, then who is signed in. It replaced a `NavigationRail`,
/// which is a phone's rail of icons drawn wider: it held no groups, no
/// garage switcher and no person, and its destinations had to be tabs.
///
/// Drawn inside every page rather than around the router, so each page knows
/// where it is from its own address ([pageLocation]).
class GarageSidebar extends ConsumerWidget {
  const GarageSidebar({super.key});

  static const double extendedWidth = 240;
  static const double compactWidth = 72;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final extended = GarageBreakpoints.isDesktop(context);
    final primary = [
      SidebarLink(
        l10n.dashboardTitle,
        Icons.dashboard_outlined,
        tabRoutes[GarageTab.dashboard]!,
        tab: true,
      ),
      SidebarLink(
        l10n.timelineTitle,
        Icons.view_timeline_outlined,
        tabRoutes[GarageTab.timeline]!,
        tab: true,
      ),
      // A driver's cars are the ones handed to them, as on the bottom bar
      // (decision 194).
      SidebarLink(
        ref.watch(isDriverProvider)
            ? l10n.companyDriverCarsTab
            : l10n.vehiclesTitle,
        Icons.directions_car_outlined,
        tabRoutes[GarageTab.vehicles]!,
        tab: true,
      ),
      SidebarLink(
        l10n.plannerTitle,
        Icons.event_note_outlined,
        tabRoutes[GarageTab.planner]!,
        tab: true,
      ),
      SidebarLink(l10n.householdTitle, Icons.people_outline, '/household'),
    ];
    final tools = [
      for (final destination in secondaryDestinations(
        l10n,
        company: ref.watch(companyConsoleVisibleProvider),
      ))
        if (destination.route != '/household')
          SidebarLink(destination.label, destination.icon, destination.route),
    ];
    final bottom = [
      for (final destination in settingsDestinations(l10n))
        SidebarLink(destination.label, destination.icon, destination.route),
    ];
    final location = pageLocation(context);
    final current = currentLink([...primary, ...tools, ...bottom], location);

    Widget item(SidebarLink link) => _SidebarItem(
      link: link,
      selected: identical(link, current),
      here: link.route == location,
      extended: extended,
    );

    return SizedBox(
      width: extended ? extendedWidth : compactWidth,
      child: FocusTraversalGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _GarageSwitcher(extended: extended),
            // The middle scrolls; the garage above and the person below stay
            // put, so a 720-pixel laptop window scrolls a list, not the frame.
            // Not the window's primary scroll view: that is the page's.
            Expanded(
              child: SingleChildScrollView(
                primary: false,
                padding: const EdgeInsets.symmetric(
                  vertical: GarageTokens.space2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final link in primary) item(link),
                    const Divider(
                      indent: GarageTokens.space4,
                      endIndent: GarageTokens.space4,
                    ),
                    for (final link in tools) item(link),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: GarageTokens.space2),
            for (final link in bottom) item(link),
            _SignedIn(extended: extended, here: location == '/settings'),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.link,
    required this.selected,
    required this.here,
    required this.extended,
  });

  final SidebarLink link;

  /// Lit: the page is this link's or sits under it.
  final bool selected;

  /// The page is this link's own, not one under it.
  final bool here;
  final bool extended;

  /// Nothing on the page the link names. A tab is gone to, and so is a link
  /// lit because the page sits under it, Vehicles on a car's fuel log or
  /// Garage on merging garages: it leads up to its section, as the crumb
  /// beside it does, where a push would put the section on top of its own
  /// page. Anything else is pushed, except from the page for an address
  /// nothing matches, where a push goes nowhere ([atUnknownAddress]).
  void _open(BuildContext context) {
    if (here) {
      return;
    }
    if (link.tab || selected || atUnknownAddress(context)) {
      context.go(link.route);
    } else {
      context.push(link.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(GarageTokens.radiusSm),
    );
    final icon = Icon(
      link.icon,
      size: 20,
      color: selected ? tokens.accent : tokens.muted,
    );
    final tile = Material(
      color: selected
          ? tokens.accent.withValues(alpha: 0.12)
          : Colors.transparent,
      shape: shape,
      child: InkWell(
        key: Key('sidebar-${link.route}'),
        customBorder: shape,
        onTap: () => _open(context),
        child: SizedBox(
          height: 40,
          child: extended
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GarageTokens.space3,
                  ),
                  child: Row(
                    children: [
                      icon,
                      const SizedBox(width: GarageTokens.space3),
                      Expanded(
                        child: Text(
                          link.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: selected ? tokens.accent : tokens.fg,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: icon),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GarageTokens.space2,
        vertical: 1,
      ),
      child: Semantics(
        container: true,
        selected: selected,
        label: extended ? null : link.label,
        // The label above names an icon to a screen reader once; the
        // tooltip is for the pointer.
        child: extended
            ? tile
            : Tooltip(
                message: link.label,
                excludeFromSemantics: true,
                child: tile,
              ),
      ),
    );
  }
}

/// Which garage you are looking at, at the top: the thing a phone has no
/// room to show. A menu only where there is something to choose, labelled or
/// not: the garage's name with an arrow from 1200 pixels, its icon below.
class _GarageSwitcher extends ConsumerWidget {
  const _GarageSwitcher({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final household = ref.watch(currentHouseholdProvider).value;
    final households = ref.watch(myHouseholdsProvider).value ?? const [];

    Widget menu({required String tooltip, required Widget child}) =>
        PopupMenuButton<String>(
          key: const Key('sidebar-garage-switcher'),
          tooltip: tooltip,
          position: PopupMenuPosition.under,
          borderRadius: BorderRadius.circular(GarageTokens.radiusSm),
          onSelected: (id) =>
              ref.read(householdControllerProvider.notifier).switchTo(id),
          itemBuilder: (context) => [
            for (final option in households)
              PopupMenuItem(
                value: option.id,
                child: Row(
                  children: [
                    Icon(
                      option.id == household?.id
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 18,
                    ),
                    const SizedBox(width: GarageTokens.space3),
                    Flexible(child: Text(option.name)),
                  ],
                ),
              ),
          ],
          child: child,
        );

    if (!extended) {
      // A link's tile in size, so the target and the shape a hover draws
      // match the links' below.
      final icon = SizedBox(
        height: 40,
        child: Center(
          child: Icon(Icons.garage_outlined, color: context.tokens.muted),
        ),
      );
      return Padding(
        padding: const EdgeInsets.all(GarageTokens.space2),
        child: households.length < 2
            ? household == null
                  ? icon
                  : Tooltip(message: household.name, child: icon)
            // Named on hover, as with one garage: the name is what the
            // icon cannot show, and the menu says the rest.
            : menu(
                tooltip: household?.name ?? l10n.householdSwitch,
                child: icon,
              ),
      );
    }
    final name = Text(
      household?.name ?? '',
      style: Theme.of(context).textTheme.titleLarge,
      overflow: TextOverflow.ellipsis,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GarageTokens.space4,
        GarageTokens.space4,
        GarageTokens.space4,
        GarageTokens.space3,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: households.length < 2
            ? name
            : menu(
                tooltip: l10n.householdSwitch,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: name),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Who is signed in, at the foot of the sidebar; a click opens Settings,
/// where the account and signing out are.
class _SignedIn extends ConsumerWidget {
  const _SignedIn({required this.extended, required this.here});

  final bool extended;

  /// The page is Settings already, so the click has nowhere new to go.
  final bool here;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(accountIdentityProvider);
    if (identity == null) {
      return const SizedBox(height: GarageTokens.space2);
    }
    final tokens = context.tokens;
    final theme = Theme.of(context);
    final name = identity.name.isEmpty ? identity.email : identity.name;
    final avatar = CircleAvatar(
      radius: 14,
      backgroundColor: tokens.accent.withValues(alpha: 0.16),
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(color: tokens.accent),
      ),
    );
    final content = extended
        ? Row(
            children: [
              avatar,
              const SizedBox(width: GarageTokens.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (identity.email.isNotEmpty && identity.email != name)
                      Text(
                        identity.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.muted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          )
        : Center(child: avatar);
    final tile = InkWell(
      key: const Key('sidebar-account'),
      borderRadius: BorderRadius.circular(GarageTokens.radiusSm),
      // Pushed, as a link that is not a tab is, and gone to from the page for
      // an address nothing matches, where a push goes nowhere.
      onTap: () {
        if (here) {
          return;
        }
        if (atUnknownAddress(context)) {
          context.go('/settings');
        } else {
          context.push('/settings');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(GarageTokens.space2),
        child: content,
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(GarageTokens.space2),
      child: extended || name.isEmpty
          ? tile
          : Tooltip(message: name, child: tile),
    );
  }
}
