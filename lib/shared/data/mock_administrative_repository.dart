import '../models/administrative_unit.dart';

abstract class AdministrativeRepository {
  Future<List<AdministrativeUnit>> getProvinces({String? query});
  Future<List<AdministrativeUnit>> getWards(String provinceCode, {String? query});
  AdministrativeUnit? getProvinceByCode(String code);
  AdministrativeUnit? getWardByCode(String code);
  String formatLocation(String? provinceCode, String? wardCode);
}

class MockAdministrativeRepository implements AdministrativeRepository {
  // Dữ liệu Mock 2 cấp hành chính Việt Nam (Tỉnh/Thành -> Xã/Phường/Đặc khu)
  // Có kèm aliases cho các địa danh cũ để hỗ trợ tìm kiếm linh hoạt.

  static const List<AdministrativeUnit> _mockProvinces = [
    AdministrativeUnit(
      code: 'VN-SG',
      name: 'TP. Hồ Chí Minh',
      type: AdministrativeType.province,
      aliases: ['Sài Gòn', 'HCM', 'TPHCM', 'TP HCM', 'Thanh pho Ho Chi Minh'],
    ),
    AdministrativeUnit(
      code: 'VN-HN',
      name: 'Hà Nội',
      type: AdministrativeType.province,
      aliases: ['Thu do Ha Noi', 'HN', 'Ha Noi'],
    ),
    AdministrativeUnit(
      code: 'VN-DN',
      name: 'Đà Nẵng',
      type: AdministrativeType.province,
      aliases: ['TP Da Nang', 'Da Nang'],
    ),
    AdministrativeUnit(
      code: 'VN-39',
      name: 'Đồng Nai',
      type: AdministrativeType.province,
      aliases: ['Dong Nai', 'Bien Hoa'],
    ),
    AdministrativeUnit(
      code: 'VN-22',
      name: 'Nghệ An',
      type: AdministrativeType.province,
      aliases: ['Nghe An', 'TP Vinh', 'Vinh', 'Xu Nghe'],
    ),
  ];

  static const List<AdministrativeUnit> _mockWards = [
    // TP. Hồ Chí Minh
    AdministrativeUnit(
      code: 'VN-SG-BN',
      name: 'Phường Bến Nghé',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['Quận 1', 'Quan 1', 'Ben Nghe', 'Trung tam Q1'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-BT',
      name: 'Phường Bến Thành',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['Quận 1', 'Quan 1', 'Ben Thanh', 'Cho Ben Thanh'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-DK',
      name: 'Phường Đa Kao',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['Quận 1', 'Quan 1', 'Da Kao', 'Dinh Tien Hoang'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-VTS',
      name: 'Phường Võ Thị Sáu',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['Quận 3', 'Quan 3', 'Vo Thi Sau'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-TD',
      name: 'Phường Thảo Điền',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['TP Thủ Đức', 'Quận 2', 'Thao Dien', 'Quan 2'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-LT',
      name: 'Phường Linh Tây',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['TP Thủ Đức', 'Quan Thu Duc', 'Linh Tay'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-TP',
      name: 'Phường Tân Phong',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['Quận 7', 'Quan 7', 'Phu My Hung', 'Tan Phong'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-TB2',
      name: 'Phường 2',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      aliases: ['Tân Bình', 'Quận Tân Bình', 'Quan Tan Binh', 'San bay Tan Son Nhat'],
    ),

    // Hà Nội
    AdministrativeUnit(
      code: 'VN-HN-HG',
      name: 'Phường Hàng Gai',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      aliases: ['Quận Hoàn Kiếm', 'Quan Hoan Kiem', 'Pho Co', 'Hang Gai'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-CD',
      name: 'Phường Cửa Đông',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      aliases: ['Quận Hoàn Kiếm', 'Quan Hoan Kiem', 'Cua Dong'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-TV',
      name: 'Phường Trúc Bạch',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      aliases: ['Trấn Vũ', 'Tran Vu', 'Quận Ba Đình', 'Quan Ba Dinh', 'Ho Tay', 'Truc Bach'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-CG',
      name: 'Phường Dịch Vọng Hậu',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      aliases: ['Quận Cầu Giấy', 'Quan Cau Giay', 'Dich Vong Hau'],
    ),

    // Đà Nẵng
    AdministrativeUnit(
      code: 'VN-DN-TT',
      name: 'Phường Thạch Thang',
      type: AdministrativeType.ward,
      parentCode: 'VN-DN',
      aliases: ['Quận Hải Châu', 'Quan Hai Chau', 'Thach Thang', 'Song Han'],
    ),
    AdministrativeUnit(
      code: 'VN-DN-AC',
      name: 'Phường An Hải Bắc',
      type: AdministrativeType.ward,
      parentCode: 'VN-DN',
      aliases: ['Quận Sơn Trà', 'Quan Son Tra', 'Bien My Khe', 'An Hai Bac'],
    ),

    // Đồng Nai
    AdministrativeUnit(
      code: 'VN-39-BH',
      name: 'Phường Trung Dũng',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      aliases: ['Thành phố Biên Hòa', 'Bien Hoa', 'Trung Dung'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LH',
      name: 'Xã Long Hưng',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      aliases: ['Thành phố Biên Hòa', 'Long Hung', 'Aqua City'],
    ),

    // Nghệ An
    AdministrativeUnit(
      code: 'VN-22-TT',
      name: 'Phường Trường Thi',
      type: AdministrativeType.ward,
      parentCode: 'VN-22',
      aliases: ['TP Vinh', 'Thành phố Vinh', 'Truong Thi', 'Quảng trường Hồ Chí Minh'],
    ),
    AdministrativeUnit(
      code: 'VN-22-QT',
      name: 'Phường Quang Trung',
      type: AdministrativeType.ward,
      parentCode: 'VN-22',
      aliases: ['TP Vinh', 'Thành phố Vinh', 'Quang Trung'],
    ),
    AdministrativeUnit(
      code: 'VN-22-HD',
      name: 'Phường Hưng Dũng',
      type: AdministrativeType.ward,
      parentCode: 'VN-22',
      aliases: ['TP Vinh', 'Thành phố Vinh', 'Hung Dung'],
    ),
    AdministrativeUnit(
      code: 'VN-22-NH',
      name: 'Phường Nghi Hương',
      type: AdministrativeType.ward,
      parentCode: 'VN-22',
      aliases: ['Thị xã Cửa Lò', 'Thi xa Cua Lo', 'Cua Lo', 'Bien Cua Lo', 'Nghi Huong'],
    ),
  ];

  @override
  Future<List<AdministrativeUnit>> getProvinces({String? query}) async {
    await Future.delayed(const Duration(milliseconds: 60)); // Giả lập độ trễ ngắn
    if (query == null || query.trim().isEmpty) {
      return List.unmodifiable(_mockProvinces);
    }
    return _mockProvinces.where((p) => p.matchesQuery(query)).toList();
  }

  @override
  Future<List<AdministrativeUnit>> getWards(String provinceCode, {String? query}) async {
    await Future.delayed(const Duration(milliseconds: 60));
    final wardsOfProvince = _mockWards.where((w) => w.parentCode == provinceCode).toList();
    if (query == null || query.trim().isEmpty) {
      return wardsOfProvince;
    }
    return wardsOfProvince.where((w) => w.matchesQuery(query)).toList();
  }

  @override
  AdministrativeUnit? getProvinceByCode(String code) {
    try {
      return _mockProvinces.firstWhere((p) => p.code == code);
    } catch (_) {
      return null;
    }
  }

  @override
  AdministrativeUnit? getWardByCode(String code) {
    try {
      return _mockWards.firstWhere((w) => w.code == code);
    } catch (_) {
      return null;
    }
  }

  @override
  String formatLocation(String? provinceCode, String? wardCode) {
    if (provinceCode == null || provinceCode.isEmpty) {
      return 'Toàn quốc';
    }
    final province = getProvinceByCode(provinceCode);
    final provinceName = province?.name ?? provinceCode;

    if (wardCode == null || wardCode.isEmpty) {
      return provinceName;
    }
    final ward = getWardByCode(wardCode);
    final wardName = ward?.name ?? wardCode;
    return '$wardName, $provinceName';
  }
}
