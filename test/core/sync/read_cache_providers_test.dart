import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/errors/app_failure.dart';
import 'package:garage/core/supabase/supabase_client_provider.dart';
import 'package:garage/core/sync/read_cache_providers.dart';
import 'package:garage/core/sync/read_cache_store.dart';

import '../../support/pump_screen.dart' show TestUserId, testUserIdProvider;

void main() {
  test(
    'another account on the phone is not shown the last one\'s marks',
    () async {
      // A session ended on the server, a refresh token refused or a sign-out
      // elsewhere, goes through neither sign-out path that forgets them, and
      // the cache lives as long as the app: the next account saw a banner
      // naming a copy it was never served.
      final container = ProviderContainer(
        overrides: [
          readCacheStoreProvider.overrideWithValue(InMemoryReadCacheStore()),
          testUserIdProvider.overrideWith(() => TestUserId('u1')),
          currentUserIdProvider.overrideWith(
            (ref) => ref.watch(testUserIdProvider),
          ),
        ],
      );
      addTearDown(container.dispose);
      final cache = container.read(readCacheProvider);
      await cache.rows(
        'fuel/v1',
        () async => [
          {'id': 'f1'},
        ],
      );
      await cache.rows(
        'fuel/v1',
        () async => throw const AppFailure(kind: AppFailureKind.network),
      );
      expect(container.read(staleReadsProvider).value.any, isTrue);

      container.read(testUserIdProvider.notifier).signIn('u2');
      container.read(currentUserIdProvider);

      expect(container.read(staleReadsProvider).value.any, isFalse);
    },
  );
}
