import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/supabase/supabase_client_provider.dart';
import 'package:garage/core/sync/pending_write.dart';
import 'package:garage/core/sync/read_cache_providers.dart';
import 'package:garage/core/sync/read_cache_store.dart';
import 'package:garage/core/sync/sync_providers.dart';
import 'package:garage/core/sync/write_queue.dart';
import 'package:garage/domain/entities/incident.dart';
import 'package:garage/features/incidents/providers/incident_providers.dart';
import 'package:http/http.dart' as http;

import '../../support/fake_supabase_http.dart';

/// A report as the app makes it — the controller, the provider's own
/// repository and the queue under it — over a server that cannot be reached
/// and then can.
void main() {
  test(
    'a report made with no signal waits on the phone, then is sent',
    () async {
      var online = false;
      final server = FakeSupabaseServer((request) {
        if (request.url.path != '/rest/v1/incidents') {
          return null;
        }
        if (!online) {
          throw http.ClientException('Connection closed while receiving data');
        }
        return (201, null);
      });
      await server.signIn();
      final queue = InMemoryPendingWriteStore();
      final container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(server.client),
          pendingWriteStoreProvider.overrideWithValue(queue),
          readCacheStoreProvider.overrideWithValue(InMemoryReadCacheStore()),
        ],
      );
      addTearDown(container.dispose);

      final saved = await container
          .read(incidentControllerProvider.notifier)
          .save(
            Incident(
              id: 'i1',
              vehicleId: 'v1',
              kind: IncidentKind.fine,
              happenedOn: DateTime.utc(2026, 10, 16),
              description: 'Parking fine, Vukovarska',
              createdBy: '',
              createdAt: DateTime.utc(2026, 10, 16, 9),
              amount: 40,
            ),
            isNew: true,
          );

      expect(saved, isTrue, reason: 'the sheet closes as saved');
      final queued = (await queue.all()).single;
      expect(queued.kind, PendingWriteKind.incident);
      expect(queued.row['created_by'], 'u1');

      online = true;
      final report = await container
          .read(syncControllerProvider.notifier)
          .run();

      expect(report.sent, 1);
      expect(await queue.all(), isEmpty);
      final sent = server.requests.lastWhere(
        (request) =>
            request.method == 'POST' &&
            request.url.path == '/rest/v1/incidents',
      );
      expect(jsonDecode(sent.body), {
        'id': 'i1',
        'kind': 'fine',
        'happened_on': '2026-10-16',
        'odometer_km': null,
        'description': 'Parking fine, Vukovarska',
        'amount': 40.0,
        'status': 'open',
        'resolved_on': null,
        'vehicle_id': 'v1',
        'created_by': 'u1',
      });
    },
  );
}
