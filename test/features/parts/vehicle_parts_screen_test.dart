import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/errors/app_failure.dart';
import 'package:garage/core/widgets/page_header.dart';
import 'package:garage/domain/entities/vehicle_part.dart';
import 'package:garage/features/maintenance/data/maintenance_repository.dart';
import 'package:garage/features/maintenance/providers/maintenance_providers.dart';
import 'package:garage/features/parts/data/vehicle_part_repository.dart';
import 'package:garage/features/parts/providers/vehicle_part_providers.dart';
import 'package:garage/features/parts/screens/vehicle_parts_screen.dart';

import '../../support/floating_button.dart';
import '../../support/pump_screen.dart';

class FakeVehiclePartRepository implements VehiclePartRepository {
  FakeVehiclePartRepository({this.parts = const [], this.failWith});

  List<VehiclePart> parts;
  final List<VehiclePart> saved = [];
  final List<String> deleted = [];

  /// Thrown by every write, for a test about what the sheet does with a
  /// refusal: a driver may read a car's parts and write none (0080).
  AppFailure? failWith;

  @override
  Future<List<VehiclePart>> forVehicle(String vehicleId) async => parts;

  @override
  Future<void> save(VehiclePart part) async {
    saved.add(part);
    if (failWith case final failure?) {
      throw failure;
    }
  }

  @override
  Future<void> delete(String id) async => deleted.add(id);
}

VehiclePart oil() => const VehiclePart(
  id: 'p1',
  vehicleId: 'v1',
  serviceTypeKey: 'service_oil_change',
  spec: '5W-30 ACEA C3',
  notes: '4.3 l with filter',
  createdBy: 'u1',
);

Future<void> pumpParts(
  WidgetTester tester,
  FakeVehiclePartRepository repository, {
  Locale? locale,
  double textScale = 1,
  Size surface = const Size(420, 1000),
  String role = 'admin',
}) async {
  await pumpScreen(
    tester,
    const VehiclePartsScreen(vehicleId: 'v1'),
    role: role,
    initialLocation: '/vehicles/v1/parts',
    locale: locale,
    textScale: textScale,
    surface: surface,
    vehicles: [testVehicle('v1', nickname: 'Golf')],
    overrides: [
      vehiclePartRepositoryProvider.overrideWithValue(repository),
      // The job picker reads the catalogue; one job is enough to pick.
      availableServiceTypesProvider('v1').overrideWith(
        (ref) async => const [ServiceType(key: 'service_oil_change')],
      ),
    ],
  );
  await tester.pumpAndSettle();
}

void main() {
  // A driver holds select on `vehicle_parts` and nothing else (0080): the
  // sheet learned to say so, and the buttons that led to it stayed.
  group('a driver, who may read what the car takes and change none', () {
    testWidgets('is offered nothing to add, edit or delete', (tester) async {
      await pumpParts(
        tester,
        FakeVehiclePartRepository(parts: [oil()]),
        role: 'driver',
      );

      expect(find.byKey(const Key('part-add')), findsNothing);
      expect(find.byKey(const Key('part-menu-p1')), findsNothing);

      await tester.tap(find.text('5W-30 ACEA C3'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('part-save')), findsNothing);
    });

    testWidgets('an empty list says so without the button', (tester) async {
      await pumpParts(tester, FakeVehiclePartRepository(), role: 'driver');

      expect(find.text('Nothing recorded for this car yet.'), findsOneWidget);
      expect(find.byKey(const Key('part-add-first')), findsNothing);
    });

    // A desk puts the button in the top bar, where it must not come back.
    testWidgets('and is offered nothing to add on a desk either', (
      tester,
    ) async {
      await pumpParts(
        tester,
        FakeVehiclePartRepository(parts: [oil()]),
        role: 'driver',
        surface: desktopSurface,
      );

      expect(find.byKey(const Key('part-add')), findsNothing);
      expect(find.text('Add what it takes'), findsNothing);
    });

    testWidgets('where the admin finds it in the top bar', (tester) async {
      await pumpParts(
        tester,
        FakeVehiclePartRepository(parts: [oil()]),
        surface: desktopSurface,
      );

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(
        find.descendant(
          of: find.byType(PageHeader),
          matching: find.byKey(const Key('part-add')),
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('the title names the car', (tester) async {
    await pumpParts(tester, FakeVehiclePartRepository());

    expect(find.text('Golf · What this car takes'), findsOneWidget);
  });

  // Roadmap item 12, the half that needs no data: a household looks a part
  // number up once and the app remembers it, keyed by the job it is for.
  testWidgets('a car with nothing recorded offers the first lookup', (
    tester,
  ) async {
    await pumpParts(tester, FakeVehiclePartRepository());

    expect(find.byKey(const Key('part-add-first')), findsOneWidget);
    expect(find.byKey(const Key('part-add')), findsNothing);
  });

  testWidgets('a recorded spec is shown under the job it is for', (
    tester,
  ) async {
    await pumpParts(tester, FakeVehiclePartRepository(parts: [oil()]));

    expect(find.text('Oil change'), findsOneWidget);
    expect(find.text('5W-30 ACEA C3'), findsOneWidget);
    expect(find.text('4.3 l with filter'), findsOneWidget);
  });

  testWidgets('and the next is added from the floating button', (tester) async {
    await pumpParts(tester, FakeVehiclePartRepository(parts: [oil()]));

    expectFloatingButton(
      tester,
      key: const Key('part-add'),
      label: 'Add what it takes',
      icon: Icons.add,
    );
  });

  testWidgets('deleting asks first, then goes through the repository', (
    tester,
  ) async {
    final repository = FakeVehiclePartRepository(parts: [oil()]);
    await pumpParts(tester, repository);

    await tester.tap(find.byKey(const Key('part-menu-p1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(repository.deleted, isEmpty, reason: 'not before confirming');

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(repository.deleted, ['p1']);
  });

  testWidgets('a new spec cannot be saved without saying what it is', (
    tester,
  ) async {
    final repository = FakeVehiclePartRepository();
    await pumpParts(tester, repository);

    await tester.tap(find.byKey(const Key('part-add-first')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('part-save')));
    await tester.pumpAndSettle();

    expect(repository.saved, isEmpty);
  });

  testWidgets('a refused save keeps the sheet open and says why', (
    tester,
  ) async {
    // A driver may read a car's parts and write none, and the sheet used to
    // answer the refusal by silently refusing to close.
    final repository = FakeVehiclePartRepository(
      failWith: const AppFailure(kind: AppFailureKind.permission),
    );
    await pumpParts(tester, repository);

    await tester.tap(find.byKey(const Key('part-add-first')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('part-job')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oil change').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('part-spec')), '5W-30');
    await tester.tap(find.byKey(const Key('part-save')));
    await tester.pumpAndSettle();

    expect(repository.saved, hasLength(1));
    expect(find.byKey(const Key('part-save')), findsOneWidget);
    expect(find.textContaining('You do not have access'), findsOneWidget);
  });

  for (final language in ['hr', 'it']) {
    testWidgets('lays out in $language on a narrow phone at a large font', (
      tester,
    ) async {
      await pumpParts(
        tester,
        FakeVehiclePartRepository(parts: [oil()]),
        locale: Locale(language),
        textScale: 1.5,
        surface: const Size(320, 2000),
      );

      expect(tester.takeException(), isNull);
    });
  }
}
