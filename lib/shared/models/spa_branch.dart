class SpaBranch {
  final String id;
  final String spaId;
  final String name;
  final String address;
  final String provinceCode;
  final String wardCode;
  final double latitude;
  final double longitude;
  final String phone;
  final bool isHeadquarters;

  const SpaBranch({
    required this.id,
    required this.spaId,
    required this.name,
    required this.address,
    required this.provinceCode,
    required this.wardCode,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.isHeadquarters = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaBranch &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
