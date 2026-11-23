import 'spa_branch.dart';
import 'spa_service.dart';

class Spa {
  final String id;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final String phone;
  final String email;
  final List<SpaBranch> branches;
  final List<SpaService> services;

  const Spa({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.phone,
    required this.email,
    this.branches = const [],
    this.services = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Spa &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
