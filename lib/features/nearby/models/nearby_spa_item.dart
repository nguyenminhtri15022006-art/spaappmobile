import '../../../shared/models/spa.dart';
import '../../../shared/models/spa_branch.dart';

class NearbySpaItem {
  final Spa spa;
  final SpaBranch branch;
  final double distanceKm;
  final double startingPrice;

  const NearbySpaItem({
    required this.spa,
    required this.branch,
    required this.distanceKm,
    required this.startingPrice,
  });

  String get formattedDistance {
    if (distanceKm < 1.0) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }
}
