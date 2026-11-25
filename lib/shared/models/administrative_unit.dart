import '../../core/utils/vietnamese_utils.dart';

enum AdministrativeType {
  province, // Tỉnh / Thành phố trực thuộc trung ương
  ward, // Xã / Phường / Thị trấn / Đặc khu
}

class AdministrativeUnit {
  final String code;
  final String name;
  final AdministrativeType type;
  final String? parentCode; // Mã tỉnh/thành nếu là xã/phường
  final List<String> aliases; // Tên cũ hoặc cách gọi thông dụng

  const AdministrativeUnit({
    required this.code,
    required this.name,
    required this.type,
    this.parentCode,
    this.aliases = const [],
  });

  bool matchesQuery(String query) {
    if (query.trim().isEmpty) return true;
    if (VietnameseUtils.containsSearch(name, query)) return true;
    for (final alias in aliases) {
      if (VietnameseUtils.containsSearch(alias, query)) return true;
    }
    if (VietnameseUtils.containsSearch(code, query)) return true;
    return false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdministrativeUnit &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
