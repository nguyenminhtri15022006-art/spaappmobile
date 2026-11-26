import 'dart:math' as math;
import '../../../shared/data/mock_spa_data.dart';
import '../models/nearby_spa_item.dart';

abstract class NearbyRepository {
  Future<List<NearbySpaItem>> getNearbySpas({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
}

class MockNearbyRepository implements NearbyRepository {
  @override
  Future<List<NearbySpaItem>> getNearbySpas({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    // Simulate brief network latency
    await Future.delayed(const Duration(milliseconds: 150));

    final spas = MockSpaData.getSpas();
    final List<NearbySpaItem> results = [];

    for (final spa in spas) {
      // Find starting price for spa
      double startPrice = 0;
      if (spa.services.isNotEmpty) {
        startPrice = spa.services
            .map((s) => s.price)
            .reduce((curr, next) => curr < next ? curr : next);
      }

      for (final branch in spa.branches) {
        final dist = _calculateDistance(
          latitude,
          longitude,
          branch.latitude,
          branch.longitude,
        );

        if (dist <= radiusKm) {
          results.add(
            NearbySpaItem(
              spa: spa,
              branch: branch,
              distanceKm: dist,
              startingPrice: startPrice,
            ),
          );
        }
      }
    }

    // Sort by distance ascending
    results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return results;
  }

  // Haversine formula to compute great-circle distance in km
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double rLat1 = _degreesToRadians(lat1);
    final double rLat2 = _degreesToRadians(lat2);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(rLat1) * math.cos(rLat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }
}
