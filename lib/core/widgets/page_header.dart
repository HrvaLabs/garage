import 'package:flutter/material.dart';
import 'package:garage/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../theme/garage_theme.dart';
import '../theme/garage_tokens.dart';

/// A step on the way to the page, in its top bar.
class Crumb {
  const Crumb(this.label, this.route);

  final String label;
  final String route;
}

/// The car a page at [location] belongs to, which its crumbs name: `v1` for
/// `/vehicles/v1/fuel`. Null on the car's own page, whose title names it, for
/// a new car, and outside Vehicles.
String? crumbCarId(String location) {
  final segments = Uri.parse(location).pathSegments;
  return segments.length >= 3 &&
          segments.first == 'vehicles' &&
          segments[1] != 'new'
      ? segments[1]
      : null;
}

/// Where a pushed page sits, read from its address.
///
/// A page below a section names it (`/household/merge` is under Garage); a
/// car's own pages name Vehicles and the car, whose name the scaffold passes
/// as [carName] because only it can read one. Until there is a name, while
/// the car loads or for a car the startup fetch does not know, the crumbs
/// stop at Vehicles rather than say it twice. A driver's Vehicles is "Cars",
/// as in the sidebar (decision 194). A section has no crumbs, the sidebar
/// already saying where it is, and neither has an address this does not know.
List<Crumb> sectionCrumbs(
  AppLocalizations l10n,
  String location, {
  String? carName,
  bool driver = false,
}) {
  final segments = Uri.parse(location).pathSegments;
  if (segments.length < 2) {
    return const [];
  }
  final section = switch (segments.first) {
    'vehicles' => Crumb(
      driver ? l10n.companyDriverCarsTab : l10n.vehiclesTitle,
      '/vehicles',
    ),
    'household' => Crumb(l10n.householdTitle, '/household'),
    'company' => Crumb(l10n.companyTitle, '/company'),
    'api' => Crumb(l10n.apiTitle, '/api'),
    _ => null,
  };
  if (section == null) {
    return const [];
  }
  final car = crumbCarId(location);
  return [
    section,
    if (car != null && carName != null) Crumb(carName, '/vehicles/$car'),
  ];
}

/// The crumbs, each a link, small and muted above the title.
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({required this.crumbs, super.key});

  /// How far a crumb's target reaches past its text on every side. Bare, the
  /// target was the small text alone, and on a tablet held sideways a crumb
  /// is touched. [PageHeader] gives up as much of its margin, so the text
  /// stays where it was.
  static const double reach = GarageTokens.space1;

  final List<Crumb> crumbs;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: context.tokens.muted);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (index, crumb) in crumbs.indexed) ...[
          // One space each side where there were two: the targets' own
          // padding is the rest of the gap.
          if (index > 0) ExcludeSemantics(child: Text(' › ', style: style)),
          Semantics(
            container: true,
            link: true,
            child: InkWell(
              key: Key('crumb-${crumb.route}'),
              borderRadius: BorderRadius.circular(GarageTokens.radiusSm),
              // Gone to, not pushed: a crumb leads up. Pushed, it would put
              // the section on top of the page under it, and back would lead
              // down again.
              onTap: () => context.go(crumb.route),
              child: Padding(
                padding: const EdgeInsets.all(reach),
                child: Text(crumb.label, style: style),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A page's top bar on a wide window: where the page sits, its title, and
/// what can be done on it, across the content pane above a rule.
///
/// Desktop chrome, in place of the app bar from [GarageBreakpoints.wide]. It
/// spans the pane beside the sidebar, not the window: a bar across the whole
/// window, back arrow first, is how a phone app looks, and beside a sidebar
/// that arrow is redundant (the sidebar is the navigation) and, on a
/// top-level page, misleading (there is nowhere to go back to). So the arrow
/// comes only with somewhere to go back to.
///
/// The title is set at content scale rather than app-bar scale, so the page
/// reads as a document with a heading; [crumbs] above it say where it sits.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.onBack,
    this.crumbs = const [],
    this.trailing = const [],
  });

  final String title;
  final List<Widget> actions;

  /// Supplied only by screens that were pushed onto something. A top-level
  /// destination leaves this null and gets no back affordance.
  final VoidCallback? onBack;

  /// Where the page sits, above its title ([sectionCrumbs]).
  final List<Crumb> crumbs;

  /// After the page's own actions, at the far end of the bar, each spaced
  /// from the last: for what a page offers beyond its own actions.
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final materialL10n = MaterialLocalizations.of(context);
    // A crumb's target reaches past its text, so the crumbs take that much of
    // the bar's margin, at the left and, when there are crumbs, at the top,
    // and the arrow and the title are inset by it: the crumbs' text, the
    // title's start and the arrow stay where they were.
    const reach = Breadcrumbs.reach;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        GarageTokens.space4 - reach,
        crumbs.isEmpty ? GarageTokens.space4 : GarageTokens.space4 - reach,
        GarageTokens.space4,
        GarageTokens.space3,
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            const SizedBox(width: reach),
            IconButton(
              onPressed: onBack,
              tooltip: materialL10n.backButtonTooltip,
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: GarageTokens.space2 - reach),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (crumbs.isNotEmpty) Breadcrumbs(crumbs: crumbs),
                Padding(
                  padding: const EdgeInsets.only(left: reach),
                  child: Text(
                    title,
                    style: theme.textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          ...actions,
          // A gap beside each rather than a padding around it: wrapped alike,
          // the quick-add was paired with a page's own act joining before it
          // and built again, losing a choice made in its dialog meanwhile.
          for (final widget in trailing) ...[
            const SizedBox(width: GarageTokens.space2),
            widget,
          ],
        ],
      ),
    );
  }
}
