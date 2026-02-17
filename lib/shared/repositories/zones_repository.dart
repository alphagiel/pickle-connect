import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/zone.dart';

final zonesRepositoryProvider = Provider<ZonesRepository>((ref) {
  return ZonesRepository();
});

class ZonesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'zones';

  /// Get all active zones
  Stream<List<AppZone>> getActiveZones() {
    return _firestore
        .collection(_collection)
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final zones = <AppZone>[];
          for (final doc in snapshot.docs) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['id'] = doc.id;
              zones.add(AppZone.fromJson(data));
            } catch (e) {
              print('Error parsing zone ${doc.id}: $e');
            }
          }
          // Sort by displayName for consistent ordering
          zones.sort((a, b) => a.displayName.compareTo(b.displayName));
          return zones;
        });
  }

  /// Get a single zone by ID
  Future<AppZone?> getZoneById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      final data = Map<String, dynamic>.from(doc.data()!);
      data['id'] = doc.id;
      return AppZone.fromJson(data);
    } catch (e) {
      print('Error fetching zone $id: $e');
      return null;
    }
  }
}
