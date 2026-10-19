import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/supabase/supabase_client_provider.dart';
import 'package:garage/core/sync/read_cache_providers.dart';
import 'package:garage/core/sync/read_cache_store.dart';
import 'package:garage/core/sync/sync_providers.dart';
import 'package:garage/core/sync/write_queue.dart';
import 'package:garage/domain/entities/fuel_entry.dart';
import 'package:garage/features/fuel/providers/fuel_providers.dart';
import 'package:http/http.dart' as http;

import '../../support/fake_supabase_http.dart';

/// A fill-up whose save timed out and landed anyway, edited with no signal,
/// then replayed: the insert finds its row already there, which used to end
/// the matter, edit and all.
void main() {
  late bool online;
  late FakeSupabaseServer server;

  /// The edits the server took. Its request log has the ones the phone tried
  /// with no signal too, which never arrived.
  late List<Map<String, dynamic>> edits;
  late InMemoryPendingWriteStore queue;
  late ProviderContainer container;

  FuelEntry fill([String? notes]) => FuelEntry(
    id: 'f1',
    vehicleId: 'v1',
    date: DateTime.utc(2026, 10, 16),
    odometerKm: 50000,
    volumeL: 40,
    total: 65,
    fullTank: true,
    missedFill: false,
    createdBy: '',
    notes: notes,
  );

  setUp(() async {
    online = false;
    edits = [];
    server = FakeSupabaseServer((request) {
      if (request.url.path != '/rest/v1/fuel_entries') {
        return null;
      }
      if (!online) {
        throw http.ClientException('Connection closed while receiving data');
      }
      return switch (request.method) {
        // The row is there: the save that timed out had landed.
        'POST' => (
          409,
          {
            'code': '23505',
            'message': 'duplicate key value violates unique constraint',
          },
        ),
        'PATCH' => () {
          edits.add(jsonDecode(request.body) as Map<String, dynamic>);
          return (
            200,
            [
              {'id': 'f1'},
            ],
          );
        }(),
        _ => null,
      };
    });
    await server.signIn();
    queue = InMemoryPendingWriteStore();
    container = ProviderContainer(
      overrides: [
        supabaseClientProvider.overrideWithValue(server.client),
        pendingWriteStoreProvider.overrideWithValue(queue),
        readCacheStoreProvider.overrideWithValue(InMemoryReadCacheStore()),
      ],
    );
    addTearDown(container.dispose);
  });

  test('an edit made with no signal still reaches it', () async {
    final fuel = container.read(fuelRepositoryProvider);
    await fuel.add(fill());
    await fuel.update(fill('Pump 4'));
    online = true;

    await container.read(syncControllerProvider.notifier).run();

    expect(await queue.all(), isEmpty);
    expect(edits.single['notes'], 'Pump 4');
  });

  test('one nobody edited is not written twice', () async {
    final fuel = container.read(fuelRepositoryProvider);
    await fuel.add(fill());
    online = true;

    await container.read(syncControllerProvider.notifier).run();

    expect(await queue.all(), isEmpty);
    expect(edits, isEmpty);
  });
}
