import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/domain/entities/household.dart';
import 'package:garage/domain/entities/vehicle_assignment.dart';
import 'package:garage/features/company/widgets/driver_on_date.dart';
import 'package:garage/features/household/data/garage_bootstrap.dart';

import '../../support/driver_log.dart';
import '../../support/fake_repositories.dart';
import '../../support/pump_screen.dart';

/// A day the log gives to nobody the viewer can see: after Ivo's window,
/// before anybody else's.
final day = DateTime.utc(2026, 9, 10);

Future<void> pumpLine(
  WidgetTester tester, {
  required String role,
  List<VehicleAssignment> assignments = const [],

  /// The startup fetch itself, for a test whose car is in another garage
  /// than the one on screen. Wins over [role].
  GarageBootstrapRepository? bootstrap,
  Future<Map<String, String>> Function()? namesFetch,
}) async {
  await pumpScreen(
    tester,
    Scaffold(
      body: DriverOnDate(vehicleId: 'v1', date: day),
    ),
    household: companyGarage,
    role: role,
    bootstrap: bootstrap,
    vehicles: [testVehicle('v1')],
    overrides: driverLog(
      assignments: assignments,
      names: const {'u1': 'Karlo', 'u3': 'Ivo'},
      namesFetch: namesFetch,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('an admin reads the whole log, so nobody means nobody', (
    tester,
  ) async {
    await pumpLine(tester, role: 'admin');

    expect(find.text('No driver assigned on this date'), findsOneWidget);
  });

  testWidgets('a driver reads only their own windows, so nobody is not '
      'claimed', (tester) async {
    // The policy shows a driver their own windows and nothing else: a day
    // outside them may well have been the previous driver's, and the line
    // under their fine must not say it was nobody's.
    await pumpLine(
      tester,
      role: 'driver',
      assignments: [
        VehicleAssignment(
          id: 'mine',
          vehicleId: 'v1',
          userId: 'u1',
          fromDate: DateTime.utc(2026, 9, 12),
        ),
      ],
    );

    expect(find.byKey(const Key('driver-on-date')), findsNothing);
  });

  testWidgets('a driver of this car\'s garage, with another company garage '
      'on screen, is not told nobody either', (tester) async {
    // Opened by URL from a garage where they are the admin: the role that
    // decides what the log can say is the car's garage's, not the one on
    // screen, as it is for the rest of the car page.
    const dostava = Household(id: 'h2', name: 'Dostava', plan: 'company');
    await pumpLine(
      tester,
      role: 'admin',
      bootstrap: FakeGarageBootstrapRepository(
        households: const [companyGarage, dostava],
        vehicles: [testVehicle('v1', householdId: 'h2')],
        roles: const {'h1': 'admin', 'h2': 'driver'},
      ),
      assignments: [
        VehicleAssignment(
          id: 'mine',
          vehicleId: 'v1',
          userId: 'u1',
          fromDate: DateTime.utc(2026, 9, 12),
        ),
      ],
    );

    expect(find.byKey(const Key('driver-on-date')), findsNothing);
  });

  testWidgets('says nothing while the names load, not "a former member"', (
    tester,
  ) async {
    // An empty name is the word for a departed member, so for the frames
    // between the log landing and the member list landing the driver of the
    // day read as somebody who had left.
    final names = Completer<Map<String, String>>();
    await pumpLine(
      tester,
      role: 'admin',
      assignments: [
        VehicleAssignment(
          id: 'ivo',
          vehicleId: 'v1',
          userId: 'u3',
          fromDate: DateTime.utc(2026, 9, 1),
        ),
      ],
      namesFetch: () => names.future,
    );

    expect(find.byKey(const Key('driver-on-date')), findsNothing);

    names.complete(const {'u3': 'Ivo'});
    await tester.pumpAndSettle();

    expect(find.text('Driver on this date: Ivo'), findsOneWidget);
  });

  testWidgets('a driver is still named on their own day', (tester) async {
    await pumpLine(
      tester,
      role: 'driver',
      assignments: [
        VehicleAssignment(
          id: 'mine',
          vehicleId: 'v1',
          userId: 'u1',
          fromDate: DateTime.utc(2026, 9, 1),
        ),
      ],
    );

    expect(find.text('Driver on this date: Karlo'), findsOneWidget);
  });
}
