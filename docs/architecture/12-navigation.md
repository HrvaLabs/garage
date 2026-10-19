# Navigation and information architecture

Forty-one routes, five bottom tabs, and one window that may be a phone or a
desktop browser. This is how they fit together, and what went wrong the last
time they did not.

## The five tabs

`lib/core/widgets/garage_bottom_nav.dart` owns the destinations. Material allows
a maximum of five in a `NavigationBar`, and all five are spent:

| Tab | Route | What it answers |
|---|---|---|
| Dashboard | `/` | What needs attention now |
| Timeline | `/timeline` | What happened, searchable |
| Vehicles | `/vehicles` | Which cars, and one car in detail |
| Planner | `/planner` | What is coming, and what to group into one visit |
| More | `/more` | Everything the other four could not hold |

On a wide window the tabs lead a sidebar instead, `GarageSidebar` (see
[The desktop sidebar](#the-desktop-sidebar)); a pushed screen keeps the sidebar
rather than swapping it for a back button, because a browser window that loses
its navigation on every push leaves the back button as the only way out
(`lib/core/widgets/page_scaffold.dart:90`). The page's title moves from an app
bar into a top bar across the content pane, with a breadcrumb (see
[The top bar](#the-top-bar)).

## Tabs cross-fade; pushed pages slide

The five tabs are peers, so moving between them has no direction. `_tabPage`
(`lib/core/router/app_router.dart:250`) wraps a tab's screen in a
`CustomTransitionPage` that fades, and a directional push transition between
peers reads as "forward" no matter which way the user actually moved.

This is a property of the **route table**, not of the screen, which is how it
came apart: `/more` was added with a plain `builder:` and quietly inherited the
platform push transition, so the one tab added last slid in sideways over the
navigation bar it was launched from while the other four dissolved. Nothing in
`more_screen.dart` was wrong and nothing there could have shown it.

`tabRoutes` in `garage_bottom_nav.dart` is now the shared list, and
`test/core/router/tab_routes_test.dart` walks it, requiring a `pageBuilder` on
every tab route. A sixth tab is impossible — Material caps at five — but a tab
changing route is not.

## The fifth tab is "More", not "Settings"

Four features are not tabs and never can be: Statistics, the trip log, fuel
stations, the calculator. The garage's own screen — members, invites, renaming —
is a fifth. They have to live somewhere, and for most of the app's life that
somewhere was called *Settings*.

Nobody looks under Settings for the people they share a car with. For an app
whose premise is shared upkeep, that was its most consequential misplacement, and
it was not the only cost: Settings had grown to 21 rows of which several were not
settings at all (API access, CSV import, backups, About, Diagnostics).

So the tab is **More**, Settings is one row inside it, and the imports, exports
and backups moved to their own screen at `/data`
(`lib/features/settings/screens/more_screen.dart`,
`lib/features/settings/screens/data_screen.dart`). The tab did not change what it
holds so much as stop lying about it. See decision 43.

**One box for every code.** A garage invite, a vehicle transfer and a lending
pass are all eight characters and indistinguishable to whoever is holding one;
each had its own entry point, and lending's was in Settings. The Vehicles
screen now has a single **I have a code** action that asks the server what the
code is (`describe_code`), says what using it will do, and only then does it.
`GuestRedeemScreen` and `/borrowed` are gone.

**A borrowed car's page is not the owner's page.** `vehicleIsMineProvider`
gates the owner menu, the odometer button and the four tabs; a borrower gets
the briefing and the actions their pass allows, including giving the car back.

**Lending** is a row in the vehicle menu, beside Transfer: both answer who else
may use this car, for a weekend or for good. It had no entry point at all until
somebody went looking for it — `test/ci/every_route_has_a_way_in_test.dart` now
fails the build for a route nothing in `lib/` opens (decision 138).

**Waiting to sync** is a row on More rather than a screen you can only reach
when something has gone wrong. Its only entry point used to be the banner that
appears while the queue is not empty, and `PRIVACY.md` had been pointing readers
at `More → Waiting to sync` all along — so the person following that sentence to
check nothing of theirs was being held on the device found no such row. It reads
"Everything has been sent." when there is nothing waiting, which is the answer
they came for. See decision 137, and `test/docs/menu_paths_test.dart`, which
holds every menu path printed in a public document to rows that exist.

`secondaryDestinations()` in `lib/core/widgets/secondary_destinations.dart` is the
single list of non-tab destinations, feeding both the desktop sidebar and the
More screen. It is one list because the two had already drifted: the old rail's
own comment said "on a phone these live under Settings", and only the garage did.

**The Company destination** leads the secondary list for an admin of a garage
on the company plan and is absent for everybody else — a driver never sees
it — through `secondaryDestinations(l10n, company: …)`
(`lib/core/widgets/secondary_destinations.dart:36`) fed by
`companyConsoleVisibleProvider`
(`lib/features/company/providers/company_providers.dart:110`). It leads because
an admin of a fleet opens the app for it more often than for the garage's own
screen. The console is a pushed page with its own tab strip, not a sixth tab:
Material caps the bar at five, and the fleet is one thing, however many views
it has. A driver's Vehicles tab is titled "My cars" on its own page
(`lib/features/vehicles/screens/vehicles_screen.dart:96`) and labelled "Cars"
in the bar (`lib/core/widgets/garage_bottom_nav.dart:62`) and the sidebar
(`lib/core/widgets/garage_sidebar.dart:85`): the bar takes one-word labels by
test, so the tab could not carry the title's two words, and the owner chose the
word (decision 194).
See [13](13-company.md#the-console).

**The tour.** `/features` (`lib/features/settings/screens/features_screen.dart`)
is one page naming every feature with a sentence and a tap that opens it,
reached from the last row of the getting-started card and from the end of the
More list. It is a list of entry points rather than a walkthrough, for the
reasons in decision 72. Tab routes are switched to with `go`, everything else
is pushed, so the back arrow always goes somewhere sensible.

**Where the review moved things (September 2026).** The UX critique's
findability table put five features four taps deep or in two places under two
names. Now: the maintenance **calendar** is a List / Calendar toggle at the top
of the Planner, garage-wide, as well as per vehicle; **tyres** are a row on the
vehicle's Car tab (decision 173) as well as a menu item; **handing a vehicle to another
garage** is a button on the Garage page beside "Invite someone", where sharing
lives; **API access** is the last row of "Your data" under "For developers"
instead of the first; the **location permission** for filling in the station
and price sits in Settings under "Fill-ups", not among import and backup; the
privacy policy is linked from More and About, not from Your data. One word per concept: "Add reminder"
everywhere (the sheet, the planner, the quick-add), "Trips" not "Trip log",
and in Croatian the vehicle's log tab is "Dnevnik" so it no longer collides
with the Timeline's "Povijest". Delete and Leave garage sit under their own
"Leave or delete" heading at the bottom of the Garage page.

The second pass (decision 76) shortened what the first screens ask for: the
empty dashboard has one filled button, "Add your first vehicle", with import
and joining as rows beneath it; the quick-add sheet leads with fuel, service
and cost as three tiles and folds the other four under "More"; the vehicle
form shows seven fields and folds engine and optional details under two
expanders, closed when adding and open when editing.

The third pass (decision 77) made the "What next" card a checklist that
stays until each row is done or it is hidden; put the vehicle as the first
row of the fill-up and reminder sheets, switchable while there is a choice;
grouped the Garage page into members and inviting, "Manage", and a folded
"Leave or delete"; and replaced the reminder sheet's service-type dropdown
with a searchable sheet that leads with the common items.

## A feature you can only reach after using it is not reachable

The failure that motivated the restructure is worth stating plainly, because it
is easy to reintroduce. On a phone, Statistics, stations and the calculator were
reachable only through unlabelled icons in the dashboard app bar. The trip log
was worse: its only entry point was a timeline row for a trip already logged.

Two guards exist against a repeat:

- `test/features/settings/more_screen_test.dart` asserts every non-tab
  destination has a labelled entry point, by key and by word.
- The same file asserts the trip log opens before any trip exists.

**And it was reintroduced anyway, in September 2026.** The route trends screen
shipped reachable only through an unlabelled icon in the trip log's toolbar —
the same shape, in the same app, with the guard already written. The guard did
not catch it because its list of routes is hand-maintained, which is the
weakness of every list of this kind in the repository. Routes is a secondary
destination now (`lib/core/widgets/secondary_destinations.dart:67`), and the
list in the test names it.

It is worth opening before a single route has been named, too: the empty state
is the thing that explains how one gets named, which is the property this
section is really about.

## Toolbars are fixed-width rows

An app bar lays its title and actions out in a row that cannot wrap. A text
control in `actions` therefore competes with the title for a width neither can
give up, and the loser is an overflow — not a wrap, not an ellipsis, an
exception. Statistics overflowed by 46 pixels at twice the default text size,
because the toolbar carried a title, a vehicle-name dropdown and an icon button.

The rule this leaves: **app-bar actions are icons; anything with a variable-width
label belongs in the body.** Statistics now puts its vehicle picker beside the
period bar (`lib/features/stats/screens/stats_screen.dart:144`), which is also
where someone would look for a filter.
**The trip log is a partial exception, knowingly.** Its toolbar still carries a
vehicle dropdown, and adding the routes icon beside it pushed "Svi automobili"
one and a half pixels past the edge at 1.5x in Croatian. The dropdown is capped
at 180 px with an ellipsis rather than moved into the body: with a title, one
icon and a bounded control the row fits, and the screen has a Croatian
narrow-phone test to keep it fitting. Moving it would be the more faithful
answer to the rule, and is worth doing the next time that screen is opened for
another reason.

`test/features/stats/stats_screen_test.dart` pumps the screen at
`TextScaler.linear(2)` and asserts both that nothing throws *and* that the filter
is still on screen — surviving by hiding the control would pass the first
assertion and lose the feature for exactly the people who need the layout to
hold.

When adding such a test, wrap the screen with
`MediaQuery.of(context).copyWith(textScaler: …)`, never a bare `MediaQueryData`:
a fresh one has a zero size, every adaptive layout in the app asks MediaQuery how
wide the window is, and the test then silently exercises the phone path.

## A fixed footer takes height the list is for

A tab that ends in a fixed block gives that block its height first and hands the
scrolling content whatever is left. The vehicle Reminders tab did exactly that —
the recalls card plus a row of three buttons, capped at 60% of the tab — so on a
phone the schedule the tab exists to show was squeezed into the strip above it.
Capping the footer stopped it overflowing at large text sizes; it did not stop
it taking.

The shape that works, and what the vehicle tabs do now:

- **Anything that is content scrolls with the content.** The recalls card is
  the last row of the Car tab's list
  (`lib/features/vehicles/screens/vehicle_detail_screen.dart:1237`), reached by
  scrolling rather than by taking room. Upkeep is one lazily built list whose
  leading rows are the schedule and whose months are the history
  (`vehicle_detail_screen.dart:1063`); the schedule is the Maintenance screen's
  own list, told that something else scrolls it
  (`lib/features/maintenance/screens/maintenance_screen.dart:194`).
- **The everyday action is the tab's own**, an `ActionPane`
  (`lib/core/widgets/primary_action.dart:64`) belonging to the tab rather than
  to the screen: a FAB on a `Scaffold` of the tab's on a phone, a button above
  the tab's content on a desk. The vehicle screen holds four tabs and one app
  bar, and hanging a tab-specific action off it would mean threading the tab
  index through a widget with no other reason to know it.
- **The once-in-a-while actions go in the menu.** The calendar and tyre sets
  moved into the vehicle's `PopupMenuButton` beside edit, transfer and report.

## Acting where you are told something

A screen that describes work and then sends you elsewhere to do it spends the
trip it exists to save. Three places carry the same prefill seam
(`showServiceEntrySheet(..., initialServiceTypeKeys: {…})`): the dashboard bundle
card, the maintenance screen, and — since the restructure — the planner
(`lib/features/planner/screens/planner_screen.dart`). All three refuse to offer
it when a bundle spans two cars, because a service entry belongs to one vehicle
and guessing which would be worse than not offering.

**The same gesture has to be the same control on every surface that offers it.**
Trimming an item out of a suggestion is an icon with a tooltip on both the
dashboard card and the planner, and both follow it with the same note once
something has been trimmed. It was a word on the planner for a while — the
dashboard had already replaced it, for reasons its own comment spells out, and
the planner kept rendering `bundleExclude` as a visible button, which Croatian
reads as "Preskoči": *Skip*, beside a brake fluid change. A string safe as a
tooltip is not automatically safe as a label.

## Entry points from the home screen

Logging a fill-up is the thing this app is opened for most often, and until
August 2026 every route to it started by launching the app and finding the
dashboard's FAB. Android offers two ways in from outside that: long-pressing
the app icon, and a widget on the home screen. Both reach the app the same way,
and neither needs a plugin. An expense has the same pair since September 2026
(decision 187): a `log_cost` shortcut and `LogCostWidget.kt`, carrying
`deep_link_log_cost` to `quickCostRoute` (`/log/cost`); everything below holds
for it with "fuel" read as "cost".

```
long-press the icon → shortcuts.xml   ┐
                                      ├→ ACTION_VIEW, explicit component,
tap the widget      → LogFuelWidget.kt┘   data = https://garage.hrva.cc/log/fuel
                                                      │
                          FlutterActivity, flutter_deeplinking_enabled
                                                      │
                                        initial route "https://…/log/fuel"
                                                      │
                                    go_router → garageRedirect → QuickEntryScreen
```

**One URL per entry point, held in step by a test.** `deep_link_log_fuel` in
`android/app/src/main/res/values/strings.xml` is what the widget spends, as
`context.getString(...)`. The shortcut cannot spend it: the launcher reads a
shortcut's intent without resolving resources, so
`android:data="@string/deep_link_log_cost"` reached Flutter as the bare id,
`/@2131689530`, and every tap on either shortcut opened go_router's "Page Not
Found" from August to October 2026. `shortcuts.xml` therefore writes the URL
out. The Dart side builds the same URL as `GarageLinks.logFuel`
(`lib/core/links/url_opener.dart:73`) from `quickFuelRoute`
(`lib/core/router/app_redirect.dart:37`), and
`test/ci/launcher_entry_points_test.dart` fails if the resource, the
shortcut's literal and the Dart link stop agreeing, or if the shortcut goes
back to a reference.

**The intents are explicit, not app links.** Both name
`cc.hrva.garage.MainActivity` directly rather than relying on the `autoVerify`
filter below. `/log` therefore never has to be a verified web path, the tap
cannot lose to a browser, and the widget keeps working on a device where link
verification failed.

**`flutter_deeplinking_enabled` is stated in the manifest** rather than left to
the engine's default. It is what turns the intent's data URI into Flutter's
initial route; with it off nothing errors — the activity starts on the
dashboard and the URL is silently dropped, which looks exactly like a working
launch.

**The route is inside both gates**, unlike `/join` and `/auth/confirm`. Those
are followed by people who are not signed in yet; this one is tapped on a phone
the app is already set up on, so `garageRedirect` handling a signed-out tap
(sign-in) and a garage-less one (onboarding) is the correct answer rather than
something the route has to special-case.

**`QuickEntryScreen` is the third empty case, and only that**
(`lib/features/vehicles/screens/quick_entry_screen.dart`). Each route hands it
the sheet to open — `showFuelEntrySheet` or `showCostEntrySheet` — and it
watches the garage, and:

| What it finds | What it does |
|---|---|
| One live vehicle | Opens the sheet for it |
| Several | `showVehiclePicker`, then the sheet |
| None, or only archived ones | Nothing; falls through to `/` |
| A failed load | The same — the dashboard says the garage could not be read |

The choice when there is more than one car is a question, not a guess: the fuel
sheet does not name the vehicle it writes to, so a wrong guess is one the
driver finds out about weeks later in the timeline. `showVehiclePicker`
(`lib/features/vehicles/widgets/vehicle_picker.dart:16`) is the dashboard's own
list, extracted so both surfaces ask the same way.

It renders an empty `Scaffold`, not a spinner. The dashboard replaces it within
a frame or two, a modal covers it after that — and an indefinite animation on a
route every one of these tests passes through means `pumpAndSettle` never
returns.

`QuickEntryTarget` (`lib/domain/entries/quick_entry_target.dart:21`) holds the rule
itself, filtering archived vehicles on the way. It is in the domain layer
because "which car did they mean" is worth testing without a widget, and
because a launcher intent has nobody standing by to correct it.

## The car's own page holds what is done at the car

The seventh critique walked twenty-three everyday tasks by tap count
(decision 156) and found the longest path in the app was starting a drive:
More › Trips › the vehicle dropdown › the car › "Start a drive", with nothing
on the owner's vehicle page, while a borrower's page offered it as its second
button. The fill-ups were nearly as far: the Economy tab's one tappable thing
was a button labelled "Fuel" below the chart, and the per-tank figures lived
only on the screen behind it.

The rule that came out of it: **an act done standing at the car is on the
car's page, without a menu.** Logging a reading and starting a drive are the
app-bar icons (`lib/features/vehicles/screens/vehicle_detail_screen.dart:398`);
while a drive is out the icon gives way to the in-progress card above the
tabs, which carries "Finish drive". Logging a fill-up is the Fuel tab's own
button (`vehicle_detail_screen.dart:737`), floating on a phone and above the
tab on a desk, as logging a service is Upkeep's
(`vehicle_detail_screen.dart:1101`). The five newest fill-ups sit
under the gauge as the fuel log's own rows
(`lib/features/fuel/widgets/fuel_entry_row.dart:20`), and "All fill-ups (N)"
(`vehicle_detail_screen.dart:898`) is the way to the rest.

Two more things the page says rather than hides: a live guest pass puts "On
loan to … until …" at the top (`vehicle_detail_screen.dart:939`), where the
only sign used to be three taps deep under the menu's "Lending"; and the
running-cost card leads the Costs tab, where the question is asked.

The tour follows the same rule as the page. A row named for something that
lives on a car opens that car when there is one and the list when there is a
choice (`lib/features/settings/screens/features_screen.dart:51`); "Fuel log"
opened the dashboard for a year, which on a screen subtitled "where each one
lives" was the one row pointing somewhere else.

## Four tabs, named for what they hold

The car's page is **Fuel · Upkeep · Car · Costs** (decision 173): what it burns
and was filled with; what it is due for, then what it has had done; the car
itself (tyres, papers, parts, the check before a long drive, open problems, the
recall check); and what it costs. It was Economy · Reminders · Services ·
Costs, with the car's own rows filed under Reminders beneath a "This car"
heading, where they and a long schedule pushed each other off the screen.

A reminder is worked out from the services logged, and a service logged is the
answer to one, which is why they share a tab and not the car's rows. The
Maintenance screen, from the menu's Calendar, is the same schedule with a
calendar beside it.

**A strip of labels is `GarageTabBar`**
(`lib/core/widgets/garage_tab_bar.dart:10`). It shares the width out when every
label fits its share and scrolls when one does not, because a fixed `TabBar`
fades a label that does not fit and throws nothing, so no layout test notices.
`test/core/widgets/garage_tab_bar_test.dart` measures the car's and the
statistics labels in every language, in the app's own font. A new language's
labels are chosen to fit a quarter of a 360-pixel phone, which is why Croatian
says "Servis" rather than "Održavanje".

## What a summary shows, it opens

A figure or a row on the dashboard is the first thing anybody taps (decision
177). A recent entry opens that entry, as it does on the Timeline
(`lib/features/timeline/open_timeline_entry.dart:22`); "Vehicles" opens the
cars, "Total spent" opens statistics on costs (`/stats?tab=costs`), and
"Average" opens statistics
(`lib/features/dashboard/widgets/household_metrics_strip.dart:56`). A screen
reached from one car says which car in its title
(`lib/features/vehicles/car_title.dart:6`), and a car out on loan says so on
its card wherever it is listed
(`lib/features/vehicles/widgets/on_loan_badge.dart:15`).

## Screens, sheets and dialogs

Three ways to be modal, and no fourth (decision 175):

- **A form is an adaptive entry sheet**, `showAdaptiveEntrySheet`
  (`lib/core/widgets/adaptive.dart:129`): a bottom sheet on a phone, a dialog
  no wider than a form on a wide window, and no drag to close, because a flick
  skipped the discard guard. Every entry sheet with a text field has a
  `DiscardGuard` (decision 79).
- **A choice is an adaptive choice**, `showAdaptiveChoice` or, for a list of
  rows, `showPickOne` (`adaptive.dart:183`,
  `lib/core/widgets/pick_one.dart:35`): a bottom sheet on a phone, as a form
  is, and on a wide window a popover by what asked for it rather than a
  dialog (below); a drag closes the sheet, since a list has nothing to lose.
- **A confirmation, a notice or a one-line prompt is a dialog**:
  `confirmDestructive` for what the person cannot undo, in red (decision 85),
  `confirmAction` for the rest, `showNotice` for something to read
  (`lib/core/widgets/confirm_delete.dart:40`, `confirm_delete.dart:118`), and
  `showTextPrompt` for one line of text (`lib/core/widgets/text_prompt.dart:9`).

**A list you move around in is a screen**, and so is anything linkable.
`test/ci/modal_surfaces_test.dart:58` fails a bare `showModalBottomSheet`,
`showDialog`, `AlertDialog` or `SimpleDialog` outside the helpers, and its
allowance names the two exceptions and why: the password-recovery dialog, which
lands before any screen exists, and the spinner over a running import.

Three surfaces are known not to fit and are left for their own decisions:
lending is a two-step flow in a sheet, the code box pops itself to push a
route, and merging garages is a screen that holds a picker and a confirmation.

## A choice on a desk

On a wide window `showAdaptiveChoice` opens a popover, `showAnchoredPopover`
(`lib/core/widgets/anchored_popover.dart:28`): a card pushed on the root
navigator, as a menu is, below and to the right of where it was asked for,
above that when there is no room below, and ending where that does when there
is no room to its right (`lib/core/widgets/anchored_popover.dart:295`),
always a margin inside the window
(`lib/core/widgets/anchored_popover.dart:306`). A click outside it or Escape
puts it away with nothing picked. A screen reader is taken into it and told
it opened by the name Material's own menus give, "Popup menu", except on
Apple's systems, where those give none either
(`lib/core/widgets/anchored_popover.dart:250`). The page under it stops being
the top while it is open and keeps its shape for that (`PageTitle`, below),
so the choice reaches the control that asked (decision 199). `showPickOne`
caps it at a menu's width, 360 pixels; the quick-add and the timeline's
filter keep a form's 480. The service types pass `centred: true` and stay a
dialog in the middle
(`lib/features/maintenance/widgets/service_type_field.dart:109`): thirty rows
and a search would cover the window from wherever they hung. A date is one of
these cards too, though not through `showAdaptiveChoice`, since a phone keeps
Material's dialog for it: on a desk `showGarageDatePicker`
(`lib/core/widgets/date_pickers.dart:54`) opens the card at a menu's width,
with a field to type the date in and the calendar under it
([10](10-localization-and-units.md#a-date-is-typed-in-the-readers-own-order)).
The card is kept inside the window but not scrolled
(`lib/core/widgets/anchored_popover.dart:309`): a builder that can be taller
than the room left scrolls itself, as the date's does at large text on the
smallest tablet held sideways (`lib/core/widgets/date_pickers.dart:311`).

Where it hangs from is settled as it opens
(`lib/core/widgets/anchored_popover.dart:148`), the first of:

1. **The last press**, which `PointerAnchor`
   (`lib/core/widgets/pointer_anchor.dart:16`) keeps from a pointer route the
   frame installs, until a key goes down. The helpers are handed a screen's
   context, not the control's, so the press is the one record of where the
   control was. A press on the control that stands for the choice (step 2)
   hangs it from that control instead, below it, as a menu button's menu
   opens: hung from the press inside it, the card covered the button's lower
   half (`lib/core/widgets/anchored_popover.dart:155`). A key the web build
   makes up, for a modifier it finds held on a pointer event, does not count
   (`lib/core/widgets/pointer_anchor.dart:46`). Nor, on the web with the
   accessibility layer on, does the press
   (`lib/core/widgets/pointer_anchor.dart:62`): a click on anything tappable
   then reaches the app as an accessibility tap, the press kept back, so the
   last press passed on is some other one.
2. **The control that stands for what it offers**, a `PopoverStandIn`
   (`lib/core/widgets/anchored_popover.dart:55`) given the same action as the
   choice's `standIn`. The top bar's Add stands for `showQuickAdd`
   (`lib/features/dashboard/widgets/quick_add_button.dart:29`), so the
   quick-add hangs from Add whether Add was pressed or a key opened it, and
   from a key so does the car it asks for next
   (`lib/features/dashboard/quick_add.dart:145`).
3. **The focused control**, unless what has the focus is the page itself:
   the route's scope, or a focus around a page that holds its keys, as tall
   as the page. A control is no taller than half the window
   (`lib/core/widgets/anchored_popover.dart:174`); hung from a page's corner,
   a popover would sit in the window's bottom left corner, over the sidebar.
4. **Nothing**, and then it is centred over the page's content pane, the
   `PopoverPane` (`lib/core/widgets/anchored_popover.dart:90`) both scaffolds
   put beside the sidebar (`lib/core/widgets/page_scaffold.dart:99`,
   `lib/core/widgets/garage_bottom_nav.dart:168`). On a page without one, or
   from a dialog, which sits in the middle itself, it is centred in the
   window.

A stand-in and a pane count only on the page on top. Every page under it
stays built, top bar and all, so each remembers its route
(`lib/core/widgets/anchored_popover.dart:126`) and is found while that route
is current (`lib/core/widgets/anchored_popover.dart:130`). The pointer route
records presses at every width and on Android too; only a popover reads
them, and a phone has none. The keyboard's handler is put back whenever a
frame starts (`lib/core/widgets/pointer_anchor.dart:32`): a widget test drops
every keyboard handler when it ends and keeps the pointer's routes, and one
added only the first time was gone from the second test on.

A ⋮ is still Material's menu (`showMenu`, through `PopupMenuButton`), rows of
one line, and a choice is this card, with the rows its phone sheet has: a
desk has the two.

## Links from outside: what Android will and will not open

Two kinds of URL open this app directly, and they work for the same reason and
fail for the same one. `web/.well-known/assetlinks.json` delegates
`handle_all_urls` for `garage.hrva.cc`, and the manifest's `autoVerify` filter
claims two prefixes: `/join` for invites and `/auth/confirm` for emailed
confirmation and password-reset links.

**Android matches an app link against the URL the person taps, not against
where it ends up.** Supabase's default `{{ .ConfirmationURL }}` points at the
project's own `/auth/v1/verify`, which 302s here afterwards. That is a host no
app claims, so the browser takes the tap and keeps it; the redirect arriving in
an already-open tab is not offered to the app. No manifest entry can fix that,
because the app was never asked.

So the templates in `supabase/templates/` build the link against this host and
carry the token hash instead:

```
{{ .SiteURL }}/auth/confirm?token_hash={{ .TokenHash }}&amp;type=email
```

`ConfirmEmailScreen` spends the hash through `verifyOTP`
(`lib/features/auth/data/supabase_auth_repository.dart:62`), which signs the
user in and — for `type=recovery` — raises `passwordRecovery`, the event
`main.dart` answers with the new-password prompt. The same URL still loads the
web build for anyone without the app, which is the common case: people register
on a phone and read mail on a laptop. That path also no longer needs a PKCE
verifier from the original device, which the old flow did.

`confirmEmailRoute` sits outside both gates in `garageRedirect` for the same
reason `/join` does: whoever follows the link is not signed in yet, and the
sign-in gate would bounce them to a form, spending nothing and losing the
single-use token.

Four files have to agree — template, manifest, assetlinks, and the parser the
screen uses — and nothing else relates them, so
`test/ci/invite_links_test.dart` does: it fails if a template reverts to
`ConfirmationURL`, if the path prefix stops matching the route, if the two
templates swap `type=email` and `type=recovery`, or if the ampersand is left
bare in what is, after all, an HTML attribute.

**An address nothing matches** opens the app's own page,
`NotFoundScreen` (`lib/core/router/not_found_screen.dart:14`), in the app's
language and with a button to the dashboard, as the router's `errorBuilder`
(`lib/core/router/app_router.dart:87`). go_router's default said "Page Not
Found" over the raw exception, in English, and it was what the launcher
shortcuts opened until decision 190. The page records the path, never the
query, as a failure, so Diagnostics can name the address. The gates still run
first: somebody signed out is sent to sign in, wherever they were going.

## The desktop sidebar

On a wide window both scaffolds draw `GarageSidebar`
(`lib/core/widgets/garage_sidebar.dart:58`) beside the page in place of the
bottom bar (decisions 81 and 198). From the desktop breakpoint, 1200 pixels, it
is labelled and 240 wide; between 900 and 1200 it is 72 wide, icons named in
tooltips. Top to bottom: the garage on screen, by name or, below 1200, as an
icon named in a tooltip, and at either width a menu when there is more than
one to choose; five primaries, the four tabs and the garage's own screen; the
tools, from `secondaryDestinations()`, the console first for an admin on the
plan; the tour, Settings, Your data and About, from `settingsDestinations()`;
and last the signed-in person, whose row opens Settings. Only the middle
scrolls, so a short window scrolls the links and not the frame.

"More" is in it at no width: a sidebar with room for everything has nothing to
fold, and `/more` stays routable. Two rows on More are not in the sidebar:
Waiting to sync, which the tour opens, as does the banner while anything waits,
and the privacy policy, which About opens.

The link a page sits under is lit: the one whose route is the longest
whole-segment prefix of the page's address (`currentLink`,
`lib/core/widgets/garage_sidebar.dart:33`), so Statistics lights Statistics,
a car's fuel log lights Vehicles, and an address no link holds lights nothing
rather than the dashboard. `pageLocation`
(`lib/core/router/page_location.dart:7`), the path of `pageAddress`
(`lib/core/router/page_location.dart:21`), reads that address from the page's
own route rather than the router's top, so a page under a pushed one still
knows where it is. A tab is gone to and anything else is pushed, so back
returns to where the reader was. A link does nothing on the page it names, and
a lit link on a page under it goes to its section, as the crumb beside it
does (`lib/core/widgets/garage_sidebar.dart:188`): it leads up, and pushed, it
put Garage on top of merging garages, with back leading down again.

The page for an address nothing matches is the one go_router builds without
route state, and asking for its state throws, so it reads the router's own
address (`lib/core/router/page_location.dart:27`); as it leaves, still drawn
while the next page arrives, it reads wherever the router has gone
(`lib/core/router/page_location.dart:32`). From that page every link goes,
the signed-in person's row included, where it would otherwise push: go_router
builds a push from the configuration it is showing, its error included, and
draws the same page again, so a pushed link did nothing there
(`lib/core/router/page_location.dart:45`). The sidebar is drawn inside each
page rather than around the router, which is how a page knows its own address,
and why the cross-fade between pages still has to hide two sidebars fading
into each other.

## The top bar

On a wide window a page names itself in a top bar, `PageHeader`
(`lib/core/widgets/page_header.dart:125`), where a phone has its app bar. Both
scaffolds draw it (`lib/core/widgets/page_scaffold.dart:105`,
`lib/core/widgets/garage_bottom_nav.dart:174`) across the content pane beside
the sidebar, above a rule; the content keeps its own column under it. The
title used to be a heading held to that column, with the page's actions at the
column's end. The bar belongs to the page, not to its text, as a tab strip
does (decision 32); a page with a strip has it under the bar, and the strip
draws the rule itself. A bar across the whole window, sidebar included, is a
phone's, so this one stops at the sidebar, and its back arrow comes only when
there is somewhere to go back to: a page opened by its address has an empty
stack. Left to right: the back arrow, the crumbs over the title, the page's
own actions, and a slot (`trailing`) for what a page offers beyond them.

On every page that slot holds the quick-add, `QuickAddButton`
(`lib/features/dashboard/widgets/quick_add_button.dart:20`): a button labelled
Add that opens what the dashboard's + opens (`showQuickAdd`,
`lib/features/dashboard/quick_add.dart:26`), so a fill-up, a service or a cost
is logged from Statistics or the console without going back to the dashboard.
Like the +, it is hidden while the garage has no car, there being nothing to
log against. A phone keeps it on the dashboard only. On a desk the popover's
three tiles keep the outline a card has on a phone
(`lib/features/dashboard/quick_add.dart:217`), which the desk's theme takes
from every other card (decision 198).

A page's main act goes in the same slot, before Add. A screen names it as a
`PrimaryAction` (`lib/core/widgets/primary_action.dart:14`) and the scaffold
presents it for the window: on a phone the floating button the screen used to
build itself, unchanged, and on a desk the page's one filled button in the top
bar, where a button floating over a list would be a phone's. Add is outlined
beside it, so the two never read as one offer twice. The dashboard's + is the
quick-add itself, which a desk's bar already has, so there it is not drawn
(`showOnWide`) and the bar holds one Add. The maintenance screen's + opens a
choice of a service or a reminder, and on a desk its label names both,
"Service or reminder", where "Add" read the same as the quick-add beside it;
on documents and parts a driver is offered no add button there either. The
slot puts its gap beside each widget rather than around it
(`lib/core/widgets/page_header.dart:198`), and the quick-add carries a key of
its own: wrapped alike, the quick-add was paired with a page's own act joining
before it as a list loaded, and built again, losing a choice made in its
dialog meanwhile.

The crumbs say where a pushed page sits, read from its address by
`pageLocation`, as the sidebar reads which link to light. `sectionCrumbs`
(`lib/core/widgets/page_header.dart:37`) names the section of any page below
one: Vehicles, Garage (`/household`), Company and API access (`/api-access`). A car's
pages, `/vehicles/<id>/fuel` and the rest, name Vehicles and then the car; the
car's own page names only Vehicles, its title being the car, and a new car is
not a car. The car's name is `vehicleProvider`'s, which the scaffold reads
(`lib/core/widgets/page_scaffold.dart:114`); until there is one, while the car
loads or for a car the startup fetch does not know, the crumbs stop at
Vehicles rather than read "Vehicles › Vehicles". A driver's Vehicles reads
"Cars", as the sidebar's link does (decision 194). A tab, any other section,
and an address `sectionCrumbs` does not know have none: the sidebar already
says where they are. A page may pass its own (`GaragePageScaffold.crumbs`);
none does.

Each crumb is a link to a screen reader as well as to the pointer, and is
gone to, not pushed (`lib/core/widgets/page_header.dart:100`). The sidebar
pushes a link that is neither a tab nor lit because that move is sideways and
back should undo it; a crumb leads up, as a lit link does, and pushing the
section on top of the page under it would make back lead down again. A
crumb's target reaches four pixels past its text on every side
(`lib/core/widgets/page_header.dart:75`), because on a tablet held sideways it
is touched, and bare it was the small text alone. The bar gives up as much of
its margin, so the crumbs' text, the title's start and the back arrow stay
where they were; a page with crumbs has a bar four pixels taller. The crumbs
know only the address: a car's maintenance opened from the planner names
Vehicles and the car, not the planner, which back returns to; and the page for
an address nothing matches, under a car, is crumbed as that car's page, as the
sidebar lights Vehicles for it.

## Addresses and titles on the web

In a browser, at any width, each page shows its own address, a tab of a
tabbed page is part of it, and the browser's tab is named after the page on
top (decision 199). A phone's browser is a browser too. Android shows no
address, and what of this reaches it is said below.

**A page's address** is the one go_router reports to the browser after each
move. By default it reported the address of the page under a pushed one, so
Statistics opened from the dashboard read `/`. `reflectPushedPagesInAddress`
(`lib/core/router/app_router.dart:66`) turns on
`optionURLReflectsImperativeAPIs` before the router is built
(`lib/core/router/app_router.dart:73`), and the page on top is reported. Each
report after the first is a new entry in the browser's history, which its
Back walks through.

**A tab's address** is `?tab=` on its page's: `/vehicles/v1?tab=costs`,
`/company?tab=deadlines`, `/stats?tab=distance`,
`/vehicles/v1/maintenance?tab=calendar`. A page with tabs wraps itself in
`RoutedTabs` (`lib/core/widgets/routed_tabs.dart:19`), which names them in
the order they are drawn; `test/ci/page_addresses_test.dart:13` fails a bare
`DefaultTabController`. It opens on the tab the address names, or on the
page's own for an address that names none it knows
(`lib/core/widgets/routed_tabs.dart:42`). That much is Android's too: the
dashboard's "Total spent" opens Statistics on costs there as well. On the web
a tab moved to is written to the address with go_router's `replace`
(`lib/core/widgets/routed_tabs.dart:164`), which keeps the page, its key and
its state, and changes only its address. It writes only while its page is the
router's top (`lib/core/widgets/routed_tabs.dart:176`): `replace` rewrites
the top page, whichever that is, and a row tapped while the tabs still move
can push another page there before they stop. A menu or a dialog over the
page is no page of the router's, so the tab is still written under one.
Android writes nothing.

**Back after a tab switch** returns to the tab before. The browser hands back
the entry before, with the stack go_router stored beside it, and go_router
restores that stack: the same page, at the address it had. `RoutedTabs` hears
the address change and moves to the tab it names
(`lib/core/widgets/routed_tabs.dart:123`), writing nothing for that move
(`lib/core/widgets/routed_tabs.dart:156`). Back to an address without a tab
lands on the first, and a name written then would be an entry over the one
Back reached, with Forward lost. Only a change in the address moves the tabs
(`lib/core/widgets/routed_tabs.dart:110`). Everything under a page hears when
a menu or a dialog opens over it, and tabs that took that for their address
changing would go back to its tab whenever one did: every time on Android,
where a tab moved to is never written.

**A tab's address loaded cold**, typed, bookmarked or reloaded, is any other
address to the host: the Worker answers it with the app, which opens that page
alone, on the tab it names, with no back arrow, there being nothing under it
to go back to. An address the host answers with a page of its own never
reaches the app, which is why API access moved from `/api`, where the public
reference is; `test/core/router/router_urls_test.dart:51` fails a route at,
or under, such an address.

**The browser's tab** is named after the page on top, "Statistics · Garage",
by `PageTitle` (`lib/core/widgets/page_title.dart:20`); the garage's own
screen, called what the app is called, is named once. Both scaffolds wrap
their page in it (`lib/core/widgets/page_scaffold.dart:67`,
`lib/core/widgets/garage_bottom_nav.dart:136`), and a screen outside them wraps
itself; `test/ci/page_addresses_test.dart:31` fails one that does neither. A
page says its name when it comes on top (`lib/core/widgets/page_title.dart:56`),
so closing Calculator over Statistics names Statistics again, and a page
underneath says nothing while it rebuilds. It is the same widget whether its
page is on top or not: a menu over a page takes the page off the top, and a
wrapper that came and went with that would build the page again under every
menu, losing the menu's choice. The name goes with the colour the app's own
title gives the window (`lib/core/widgets/page_title.dart:74`), which the web
paints its bar in. Off the web nothing is named.
