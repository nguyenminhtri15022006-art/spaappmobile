class SpaService {
  final String id;
  final String spaId;
  final String categoryId;
  final String name;
  final String description;
  final int durationMinutes;
  final double price;
  final String imageUrl;
  final double rating;

  const SpaService({
    required this.id,
    required this.spaId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.imageUrl,
    this.rating = 5.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaService &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
