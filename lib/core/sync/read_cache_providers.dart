import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../supabase/supabase_client_provider.dart';
import 'read_cache.dart';
import 'read_cache_store.dart';

/// Where a read's last good rows are kept. Overridden in tests, which must
/// not reach for the device's preferences.
final readCacheStoreProvider = Provider<ReadCacheStore>((ref) {
  return PrefsReadCacheStore();
});

final readCacheProvider = Provider<ReadCache>((ref) {
  final cache = ReadCache(
    store: ref.watch(readCacheStoreProvider),
    userId: () => ref.read(currentUserIdProvider),
  );
  // The marks are kept by list, not by account. A sign-out the person asks
  // for forgets them, but a session ended on the server goes through no
  // sign-out, and the next account on the phone would be shown a copy it was
  // never served.
  ref.listen(currentUserIdProvider, (previous, next) {
    if (previous != next) {
      cache.unmarkAll();
    }
  });
  return cache;
});

/// Which reads are being shown from a copy, for the banner.
final staleReadsProvider = Provider<ValueListenable<StaleReads>>((ref) {
  return ref.watch(readCacheProvider).stale;
});
