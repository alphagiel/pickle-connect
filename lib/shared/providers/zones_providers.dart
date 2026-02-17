import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/zone.dart';
import '../repositories/zones_repository.dart';
import '../../core/utils/stream_retry.dart';

/// Provider for all active zones (cached, auto-updates from Firestore)
final activeZonesProvider = StreamProvider<List<AppZone>>((ref) {
  final repository = ref.watch(zonesRepositoryProvider);
  return retryStream(() => repository.getActiveZones());
});

/// Provider to look up a single zone by ID from the cached list
final zoneByIdProvider = Provider.family<AppZone?, String>((ref, zoneId) {
  final zonesAsync = ref.watch(activeZonesProvider);
  return zonesAsync.whenOrNull(
    data: (zones) {
      try {
        return zones.firstWhere((z) => z.id == zoneId);
      } catch (_) {
        return null;
      }
    },
  );
});
