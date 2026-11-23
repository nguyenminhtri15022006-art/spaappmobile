class ServiceCategory {
  final String id;
  final String name;
  final String iconName; // e.g. 'spa', 'brush', 'face', 'accessibility'
  final String description;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.iconName,
    this.description = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
