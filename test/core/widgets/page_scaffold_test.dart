import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/core/widgets/garage_sidebar.dart';
import 'package:garage/core/widgets/page_header.dart';
import 'package:garage/domain/account/account_identity.dart';
import 'package:garage/domain/entities/household.dart';
import 'package:garage/domain/entities/vehicle.dart';
import 'package:garage/features/auth/providers/auth_providers.dart';
import 'package:garage/features/household/providers/household_providers.dart';
import 'package:garage/features/vehicles/providers/vehicle_providers.dart';
import 'package:garage/l10n/app_localizations.dart';
import 'package:garage/core/widgets/page_scaffold.dart';

import '../../support/pump_screen.dart';

Future<NavigationLog> pumpPage(
  WidgetTester tester, {
  required Size surface,
  List<Widget> actions = const [],
  String initialLocation = '/vehicles/v1/fuel',
}) {
  return pumpScreen(
    tester,
    GaragePageScaffold(title: 'Fuel', actions: actions, body: const SizedBox()),
    initialLocation: initialLocation,
    surface: surface,
  );
}

void main() {
  testWidgets('a phone gets the app bar it expects', (tester) async {
    await pumpPage(tester, surface: const Size(400, 900));
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(PageHeader), findsNothing);
  });

  testWidgets('a desktop window titles the page in its content', (
    tester,
  ) async {
    await pumpPage(tester, surface: const Size(1400, 900));
    await tester.pumpAndSettle();

    expect(find.byType(PageHeader), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
  });

  testWidgets('a page pushed onto something keeps a way back', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        // The sidebar names the household and the signed-in account, so it
        // needs a scope that answers for both rather than reaching for a real
        // Supabase client.
        overrides: [
          currentHouseholdProvider.overrideWith((ref) async => testHousehold),
          accountIdentityProvider.overrideWithValue(
            const AccountIdentity(name: 'Karlo', email: 'karlo@example.com'),
          ),
        ],
        child: MaterialApp(
          // The sidebar is localized, and the real app always has these;
          // without them it throws rather than rendering.
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const GaragePageScaffold(
                      title: 'Fuel',
                      body: SizedBox(),
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('a page opened directly offers no dead back button', (
    tester,
  ) async {
    // On the web a screen can be the whole history, for example someone
    // pasting a link to a vehicle. A back arrow with an empty stack is the
    // phone chrome this layout exists to remove.
    await pumpPage(tester, surface: const Size(1400, 900));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('the title shows at either width', (tester) async {
    for (final surface in [const Size(1400, 900), const Size(400, 900)]) {
      await pumpPage(tester, surface: surface);
      await tester.pumpAndSettle();

      expect(find.text('Fuel'), findsOneWidget);
    }
  });

  testWidgets('actions survive both presentations', (tester) async {
    for (final surface in [const Size(1400, 900), const Size(400, 900)]) {
      await pumpPage(
        tester,
        surface: surface,
        actions: [
          IconButton(
            key: const Key('action'),
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action')), findsOneWidget);
    }
  });

  // Statistics, the calculator, the stations and the household screen are all
  // pushed pages. On a desktop window they replaced the whole window with a
  // bare page, so the sidebar vanished and the only way anywhere else was the
  // browser's back button — a phone's navigation model on a screen with room
  // for a sidebar.
  testWidgets('a desktop window keeps the navigation while it is open', (
    tester,
  ) async {
    await pumpPage(tester, surface: const Size(1400, 900));
    await tester.pumpAndSettle();

    expect(find.byType(GarageSidebar), findsOneWidget);
  });

  testWidgets('and lights the section it sits under, not a tab', (
    tester,
  ) async {
    // Merging garages is part of the garage's own screen, a section that is
    // not one of the tabs.
    await pumpPage(
      tester,
      surface: const Size(1400, 900),
      initialLocation: '/household/merge',
    );
    await tester.pumpAndSettle();

    bool lit(String route) => tester
        .widget<Semantics>(
          find
              .ancestor(
                of: find.byKey(Key('sidebar-$route')),
                matching: find.byType(Semantics),
              )
              .first,
        )
        .properties
        .selected!;
    expect(lit('/household'), isTrue);
    for (final tab in ['/', '/timeline', '/vehicles', '/planner']) {
      expect(lit(tab), isFalse, reason: tab);
    }
  });

  testWidgets('a phone keeps the back arrow instead, having no room', (
    tester,
  ) async {
    await pumpPage(tester, surface: const Size(400, 900));
    await tester.pumpAndSettle();

    expect(find.byType(GarageSidebar), findsNothing);
  });

  testWidgets('the top bar runs the width of the pane', (tester) async {
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Fuel', body: SizedBox()),
      initialLocation: '/vehicles/v1/fuel',
    );
    await tester.pumpAndSettle();

    // Sidebar 240 and its rule 1: the rest of a 1440 window is the pane.
    expect(tester.getSize(find.byType(PageHeader)).width, 1440 - 241);
  });

  testWidgets('a car\'s page on a desk says where it is, and leads there', (
    tester,
  ) async {
    final log = await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Golf · Fuel', body: SizedBox()),
      initialLocation: '/vehicles/v1/fuel',
      vehicles: [testVehicle('v1', nickname: 'Golf')],
      extraRoutes: const ['/vehicles/v1'],
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('crumb-/vehicles')), findsOneWidget);
    expect(find.byKey(const Key('crumb-/vehicles/v1')), findsOneWidget);
    expect(find.text('Golf'), findsOneWidget);

    await tester.tap(find.byKey(const Key('crumb-/vehicles/v1')));
    await tester.pumpAndSettle();
    expect(log.last, '/vehicles/v1');
  });

  group('the car\'s crumb waits for its name', () {
    // A crumb standing in for the car with the section's word would read
    // "Vehicles › Vehicles".
    Finder vehiclesInTopBar() => find.descendant(
      of: find.byType(PageHeader),
      matching: find.text('Vehicles'),
    );

    testWidgets('while the car loads', (tester) async {
      await pumpDesktop(
        tester,
        const GaragePageScaffold(title: 'Fuel', body: SizedBox()),
        initialLocation: '/vehicles/v1/fuel',
        overrides: [
          vehicleProvider(
            'v1',
          ).overrideWith((ref) => Completer<Vehicle?>().future),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('crumb-/vehicles')), findsOneWidget);
      expect(find.byKey(const Key('crumb-/vehicles/v1')), findsNothing);
      expect(vehiclesInTopBar(), findsOneWidget);
    });

    testWidgets('and for a car the startup fetch does not know', (
      tester,
    ) async {
      await pumpDesktop(
        tester,
        const GaragePageScaffold(title: 'Fuel', body: SizedBox()),
        initialLocation: '/vehicles/v9/fuel',
        vehicles: [testVehicle('v1', nickname: 'Golf')],
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('crumb-/vehicles')), findsOneWidget);
      expect(find.byKey(const Key('crumb-/vehicles/v9')), findsNothing);
      expect(vehiclesInTopBar(), findsOneWidget);
    });
  });

  testWidgets('a driver\'s crumb says Cars, as the sidebar does', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Golf · Fuel', body: SizedBox()),
      initialLocation: '/vehicles/v1/fuel',
      vehicles: [testVehicle('v1', nickname: 'Golf')],
      household: const Household(id: 'h1', name: 'Prijevoz', plan: 'company'),
      role: 'driver',
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('crumb-/vehicles')),
        matching: find.text('Cars'),
      ),
      findsOneWidget,
    );
    expect(find.text('Vehicles'), findsNothing);
  });

  testWidgets('a page that names its own crumbs is taken at its word', (
    tester,
  ) async {
    await pumpDesktop(
      tester,
      const GaragePageScaffold(title: 'Fuel', crumbs: [], body: SizedBox()),
      initialLocation: '/vehicles/v1/fuel',
      vehicles: [testVehicle('v1', nickname: 'Golf')],
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('crumb-/vehicles')), findsNothing);
  });

  testWidgets('a phone has no crumbs, its app bar is enough', (tester) async {
    await pumpPage(tester, surface: const Size(400, 900));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('crumb-/vehicles')), findsNothing);
  });
}
