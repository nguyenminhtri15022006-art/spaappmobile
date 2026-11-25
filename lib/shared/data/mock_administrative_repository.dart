import '../models/administrative_unit.dart';

abstract class AdministrativeRepository {
  Future<List<AdministrativeUnit>> getProvinces({String? query});
  Future<List<AdministrativeUnit>> getWards(String provinceCode, {String? query});
  AdministrativeUnit? getProvinceByCode(String code);
  AdministrativeUnit? getWardByCode(String code);
  String formatLocation(String? provinceCode, String? wardCode);
}

class MockAdministrativeRepository implements AdministrativeRepository {
  // Dữ liệu Đơn vị hành chính Việt Nam theo mô hình 34 Tỉnh/Thành phố (từ 01/07/2025)
  // và các đơn vị hành chính cấp xã (Phường / Xã / Thị trấn / Đặc khu).
  // Hệ thống địa phương 2 cấp tinh gọn (Tỉnh -> Xã/Phường), hỗ trợ alias tìm kiếm theo quận/huyện cũ.

  static const List<AdministrativeUnit> _provinces = [
    // 6 Thành phố trực thuộc Trung ương
    AdministrativeUnit(
      code: 'VN-HN',
      name: 'Thành phố Hà Nội',
      type: AdministrativeType.province,
      aliases: ['Thủ đô Hà Nội', 'Hà Nội', 'Ha Noi', 'HN', 'Thủ đô'],
    ),
    AdministrativeUnit(
      code: 'VN-SG',
      name: 'Thành phố Hồ Chí Minh',
      type: AdministrativeType.province,
      aliases: [
        'Sài Gòn',
        'Sai Gon',
        'TP.HCM',
        'TPHCM',
        'HCM',
        'Bình Dương',
        'Binh Duong',
        'Bà Rịa Vũng Tàu',
        'Vũng Tàu',
        'Vung Tau',
      ],
    ),
    AdministrativeUnit(
      code: 'VN-DN',
      name: 'Thành phố Đà Nẵng',
      type: AdministrativeType.province,
      aliases: ['Đà Nẵng', 'Da Nang', 'Quảng Nam', 'Quang Nam', 'Hội An', 'Hoi An'],
    ),
    AdministrativeUnit(
      code: 'VN-HP',
      name: 'Thành phố Hải Phòng',
      type: AdministrativeType.province,
      aliases: ['Hải Phòng', 'Hai Phong', 'Hải Dương', 'Hai Duong'],
    ),
    AdministrativeUnit(
      code: 'VN-CT',
      name: 'Thành phố Cần Thơ',
      type: AdministrativeType.province,
      aliases: ['Cần Thơ', 'Can Tho', 'Hậu Giang', 'Hau Giang', 'Sóc Trăng', 'Soc Trang', 'Tây Đô'],
    ),
    AdministrativeUnit(
      code: 'VN-HUE',
      name: 'Thành phố Huế',
      type: AdministrativeType.province,
      aliases: ['Huế', 'Hue', 'Thừa Thiên Huế', 'Thua Thien Hue', 'Cố đô Huế'],
    ),

    // 28 Tỉnh
    AdministrativeUnit(
      code: 'VN-QN',
      name: 'Tỉnh Quảng Ninh',
      type: AdministrativeType.province,
      aliases: ['Quảng Ninh', 'Quang Ninh', 'Hạ Long', 'Ha Long'],
    ),
    AdministrativeUnit(
      code: 'VN-CB',
      name: 'Tỉnh Cao Bằng',
      type: AdministrativeType.province,
      aliases: ['Cao Bằng', 'Cao Bang'],
    ),
    AdministrativeUnit(
      code: 'VN-LS',
      name: 'Tỉnh Lạng Sơn',
      type: AdministrativeType.province,
      aliases: ['Lạng Sơn', 'Lang Son'],
    ),
    AdministrativeUnit(
      code: 'VN-LC',
      name: 'Tỉnh Lai Châu',
      type: AdministrativeType.province,
      aliases: ['Lai Châu', 'Lai Chau'],
    ),
    AdministrativeUnit(
      code: 'VN-DB',
      name: 'Tỉnh Điện Biên',
      type: AdministrativeType.province,
      aliases: ['Điện Biên', 'Dien Bien', 'Điện Biên Phủ'],
    ),
    AdministrativeUnit(
      code: 'VN-SL',
      name: 'Tỉnh Sơn La',
      type: AdministrativeType.province,
      aliases: ['Sơn La', 'Son La', 'Mộc Châu', 'Moc Chau'],
    ),
    AdministrativeUnit(
      code: 'VN-TH',
      name: 'Tỉnh Thanh Hóa',
      type: AdministrativeType.province,
      aliases: ['Thanh Hóa', 'Thanh Hoa', 'Sầm Sơn'],
    ),
    AdministrativeUnit(
      code: 'VN-22',
      name: 'Tỉnh Nghệ An',
      type: AdministrativeType.province,
      aliases: ['Nghệ An', 'Nghe An', 'TP Vinh', 'Vinh', 'Xứ Nghệ'],
    ),
    AdministrativeUnit(
      code: 'VN-HT',
      name: 'Tỉnh Hà Tĩnh',
      type: AdministrativeType.province,
      aliases: ['Hà Tĩnh', 'Ha Tinh'],
    ),
    AdministrativeUnit(
      code: 'VN-TQ',
      name: 'Tỉnh Tuyên Quang',
      type: AdministrativeType.province,
      aliases: ['Tuyên Quang', 'Tuyen Quang', 'Hà Giang', 'Ha Giang'],
    ),
    AdministrativeUnit(
      code: 'VN-LCA',
      name: 'Tỉnh Lào Cai',
      type: AdministrativeType.province,
      aliases: ['Lào Cai', 'Lao Cai', 'Sa Pa', 'Sapa', 'Yên Bái', 'Yen Bai'],
    ),
    AdministrativeUnit(
      code: 'VN-TN',
      name: 'Tỉnh Thái Nguyên',
      type: AdministrativeType.province,
      aliases: ['Thái Nguyên', 'Thai Nguyen', 'Bắc Kạn', 'Bac Kan'],
    ),
    AdministrativeUnit(
      code: 'VN-PT',
      name: 'Tỉnh Phú Thọ',
      type: AdministrativeType.province,
      aliases: ['Phú Thọ', 'Phu Tho', 'Vĩnh Phúc', 'Vinh Phuc', 'Hòa Bình', 'Hoa Binh', 'Việt Trì'],
    ),
    AdministrativeUnit(
      code: 'VN-BN',
      name: 'Tỉnh Bắc Ninh',
      type: AdministrativeType.province,
      aliases: ['Bắc Ninh', 'Bac Ninh', 'Bắc Giang', 'Bac Giang', 'Kinh Bắc'],
    ),
    AdministrativeUnit(
      code: 'VN-HY',
      name: 'Tỉnh Hưng Yên',
      type: AdministrativeType.province,
      aliases: ['Hưng Yên', 'Hung Yen', 'Thái Bình', 'Thai Binh'],
    ),
    AdministrativeUnit(
      code: 'VN-NB',
      name: 'Tỉnh Ninh Bình',
      type: AdministrativeType.province,
      aliases: ['Ninh Bình', 'Ninh Binh', 'Nam Định', 'Nam Dinh', 'Hà Nam', 'Ha Nam'],
    ),
    AdministrativeUnit(
      code: 'VN-QT',
      name: 'Tỉnh Quảng Trị',
      type: AdministrativeType.province,
      aliases: ['Quảng Trị', 'Quang Tri', 'Quảng Bình', 'Quang Binh', 'Đồng Hới'],
    ),
    AdministrativeUnit(
      code: 'VN-QNG',
      name: 'Tỉnh Quảng Ngãi',
      type: AdministrativeType.province,
      aliases: ['Quảng Ngãi', 'Quang Ngai', 'Kon Tum', 'Măng Đen'],
    ),
    AdministrativeUnit(
      code: 'VN-GL',
      name: 'Tỉnh Gia Lai',
      type: AdministrativeType.province,
      aliases: ['Gia Lai', 'Pleiku', 'Bình Định', 'Binh Dinh', 'Quy Nhơn', 'Quy Nhon'],
    ),
    AdministrativeUnit(
      code: 'VN-DL',
      name: 'Tỉnh Đắk Lắk',
      type: AdministrativeType.province,
      aliases: ['Đắk Lắk', 'Dak Lak', 'Buôn Ma Thuột', 'Phú Yên', 'Phu Yen', 'Tuy Hòa'],
    ),
    AdministrativeUnit(
      code: 'VN-KH',
      name: 'Tỉnh Khánh Hòa',
      type: AdministrativeType.province,
      aliases: ['Khánh Hòa', 'Khanh Hoa', 'Nha Trang', 'Ninh Thuận', 'Ninh Thuan', 'Phan Rang'],
    ),
    AdministrativeUnit(
      code: 'VN-LD',
      name: 'Tỉnh Lâm Đồng',
      type: AdministrativeType.province,
      aliases: ['Lâm Đồng', 'Lam Dong', 'Đà Lạt', 'Dalat', 'Đắk Nông', 'Dak Nong', 'Bình Thuận', 'Phan Thiết'],
    ),
    AdministrativeUnit(
      code: 'VN-39',
      name: 'Tỉnh Đồng Nai',
      type: AdministrativeType.province,
      aliases: ['Đồng Nai', 'Dong Nai', 'Biên Hòa', 'Bien Hoa', 'Bình Phước', 'Binh Phuoc', 'Đồng Xoài'],
    ),
    AdministrativeUnit(
      code: 'VN-TNI',
      name: 'Tỉnh Tây Ninh',
      type: AdministrativeType.province,
      aliases: ['Tây Ninh', 'Tay Ninh', 'Long An', 'Tân An'],
    ),
    AdministrativeUnit(
      code: 'VN-DT',
      name: 'Tỉnh Đồng Tháp',
      type: AdministrativeType.province,
      aliases: ['Đồng Tháp', 'Dong Thap', 'Cao Lãnh', 'Tiền Giang', 'Tien Giang', 'Mỹ Tho'],
    ),
    AdministrativeUnit(
      code: 'VN-VL',
      name: 'Tỉnh Vĩnh Long',
      type: AdministrativeType.province,
      aliases: ['Vĩnh Long', 'Vinh Long', 'Bến Tre', 'Ben Tre', 'Trà Vinh', 'Tra Vinh'],
    ),
    AdministrativeUnit(
      code: 'VN-AG',
      name: 'Tỉnh An Giang',
      type: AdministrativeType.province,
      aliases: ['An Giang', 'Long Xuyên', 'Châu Đốc', 'Kiên Giang', 'Kien Giang', 'Rạch Giá', 'Phú Quốc', 'Phu Quoc'],
    ),
    AdministrativeUnit(
      code: 'VN-CM',
      name: 'Tỉnh Cà Mau',
      type: AdministrativeType.province,
      aliases: ['Cà Mau', 'Ca Mau', 'Bạc Liêu', 'Bac Lieu'],
    ),
  ];

  static const List<AdministrativeUnit> _wards = [
    // 1. Thành phố Hà Nội
    AdministrativeUnit(
      code: 'VN-HN-HG',
      name: 'Phường Hàng Gai',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      districtName: 'Quận Hoàn Kiếm',
      aliases: ['Pho Co', 'Hang Gai', 'Hoan Kiem'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-CD',
      name: 'Phường Cửa Đông',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      districtName: 'Quận Hoàn Kiếm',
      aliases: ['Cua Dong', 'Hoan Kiem'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-TV',
      name: 'Phường Trúc Bạch',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      districtName: 'Quận Ba Đình',
      aliases: ['Truc Bach', 'Tran Vu', 'Ho Tay', 'Ba Dinh'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-CG',
      name: 'Phường Dịch Vọng Hậu',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      districtName: 'Quận Cầu Giấy',
      aliases: ['Cau Giay', 'Dich Vong Hau'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-TX',
      name: 'Phường Thanh Xuân Trung',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      districtName: 'Quận Thanh Xuân',
      aliases: ['Thanh Xuan', 'Nguyen Trai'],
    ),
    AdministrativeUnit(
      code: 'VN-HN-HM',
      name: 'Phường Hoàng Liệt',
      type: AdministrativeType.ward,
      parentCode: 'VN-HN',
      districtName: 'Quận Hoàng Mai',
      aliases: ['Hoang Mai', 'Linh Dam'],
    ),

    // 2. Thành phố Hồ Chí Minh
    AdministrativeUnit(
      code: 'VN-SG-BN',
      name: 'Phường Bến Nghé',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'Quận 1',
      aliases: ['Ben Nghe', 'Trung tam Q1', 'Dong Khoi'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-BT',
      name: 'Phường Bến Thành',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'Quận 1',
      aliases: ['Ben Thanh', 'Cho Ben Thanh'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-DK',
      name: 'Phường Đa Kao',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'Quận 1',
      aliases: ['Da Kao', 'Dinh Tien Hoang'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-VTS',
      name: 'Phường Võ Thị Sáu',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'Quận 3',
      aliases: ['Vo Thi Sau'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-TD',
      name: 'Phường Thảo Điền',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'TP. Thủ Đức',
      aliases: ['Quận 2', 'Thao Dien', 'Quan 2', 'Thu Duc'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-LT',
      name: 'Phường Linh Tây',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'TP. Thủ Đức',
      aliases: ['Quan Thu Duc', 'Linh Tay', 'Thu Duc'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-TP',
      name: 'Phường Tân Phong',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'Quận 7',
      aliases: ['Phu My Hung', 'Tan Phong'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-TB2',
      name: 'Phường 2',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'Quận Tân Bình',
      aliases: ['Tân Bình', 'Quan Tan Binh', 'San bay Tan Son Nhat'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-BD',
      name: 'Phường Phú Lợi',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'TP. Thủ Dầu Một',
      aliases: ['Bình Dương', 'Thu Dau Mot', 'Binh Duong'],
    ),
    AdministrativeUnit(
      code: 'VN-SG-VT',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-SG',
      districtName: 'TP. Vũng Tàu',
      aliases: ['Bà Rịa Vũng Tàu', 'Vung Tau', 'Bai Truoc'],
    ),

    // 3. Thành phố Đà Nẵng
    AdministrativeUnit(
      code: 'VN-DN-TT',
      name: 'Phường Thạch Thang',
      type: AdministrativeType.ward,
      parentCode: 'VN-DN',
      districtName: 'Quận Hải Châu',
      aliases: ['Thach Thang', 'Song Han'],
    ),
    AdministrativeUnit(
      code: 'VN-DN-AC',
      name: 'Phường An Hải Bắc',
      type: AdministrativeType.ward,
      parentCode: 'VN-DN',
      districtName: 'Quận Sơn Trà',
      aliases: ['Bien My Khe', 'An Hai Bac'],
    ),
    AdministrativeUnit(
      code: 'VN-DN-HA',
      name: 'Phường Minh An',
      type: AdministrativeType.ward,
      parentCode: 'VN-DN',
      districtName: 'TP. Hội An',
      aliases: ['Quảng Nam', 'Hoi An', 'Pho Co Hoi An', 'Quang Nam'],
    ),
    AdministrativeUnit(
      code: 'VN-DN-TK',
      name: 'Phường Tam Kỳ',
      type: AdministrativeType.ward,
      parentCode: 'VN-DN',
      aliases: ['Quảng Nam', 'TP Tam Kỳ', 'Tam Ky', 'Quang Nam'],
    ),

    // 4. Thành phố Hải Phòng
    AdministrativeUnit(
      code: 'VN-HP-HB',
      name: 'Phường Hoàng Văn Thụ',
      type: AdministrativeType.ward,
      parentCode: 'VN-HP',
      aliases: ['Quận Hồng Bàng', 'Hong Bang', 'Hai Phong'],
    ),
    AdministrativeUnit(
      code: 'VN-HP-NP',
      name: 'Phường Ngô Quyền',
      type: AdministrativeType.ward,
      parentCode: 'VN-HP',
      aliases: ['Quận Ngô Quyền', 'Ngo Quyen'],
    ),
    AdministrativeUnit(
      code: 'VN-HP-HD',
      name: 'Phường Lê Thanh Nghị',
      type: AdministrativeType.ward,
      parentCode: 'VN-HP',
      aliases: ['Hải Dương', 'TP Hải Dương', 'Hai Duong'],
    ),

    // 5. Thành phố Cần Thơ
    AdministrativeUnit(
      code: 'VN-CT-NK',
      name: 'Phường Ninh Kiều',
      type: AdministrativeType.ward,
      parentCode: 'VN-CT',
      aliases: ['Quận Ninh Kiều', 'Ben Ninh Kieu', 'Can Tho', 'Ninh Kieu'],
    ),
    AdministrativeUnit(
      code: 'VN-CT-CR',
      name: 'Phường Cái Răng',
      type: AdministrativeType.ward,
      parentCode: 'VN-CT',
      aliases: ['Quận Cái Răng', 'Cho noi Cai Rang', 'Cai Rang'],
    ),
    AdministrativeUnit(
      code: 'VN-CT-HG',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-CT',
      aliases: ['Hậu Giang', 'TP Vị Thanh', 'Vi Thanh', 'Hau Giang'],
    ),
    AdministrativeUnit(
      code: 'VN-CT-ST',
      name: 'Phường 2',
      type: AdministrativeType.ward,
      parentCode: 'VN-CT',
      aliases: ['Sóc Trăng', 'TP Sóc Trăng', 'Soc Trang'],
    ),

    // 6. Thành phố Huế
    AdministrativeUnit(
      code: 'VN-HUE-VT',
      name: 'Phường Vĩnh Ninh',
      type: AdministrativeType.ward,
      parentCode: 'VN-HUE',
      aliases: ['Huế', 'Thừa Thiên Huế', 'Vinh Ninh', 'Song Huong'],
    ),
    AdministrativeUnit(
      code: 'VN-HUE-PH',
      name: 'Phường Phú Hội',
      type: AdministrativeType.ward,
      parentCode: 'VN-HUE',
      aliases: ['Huế', 'Phu Hoi', 'Pho Tay Hue'],
    ),
    AdministrativeUnit(
      code: 'VN-HUE-TH',
      name: 'Phường Thuận Thành',
      type: AdministrativeType.ward,
      parentCode: 'VN-HUE',
      aliases: ['Đại Nội', 'Kinh Thanh Hue', 'Thuan Thanh'],
    ),

    // 7. Tỉnh Quảng Ninh
    AdministrativeUnit(
      code: 'VN-QN-HL',
      name: 'Phường Bãi Cháy',
      type: AdministrativeType.ward,
      parentCode: 'VN-QN',
      aliases: ['TP Hạ Long', 'Ha Long', 'Bai Chay'],
    ),
    AdministrativeUnit(
      code: 'VN-QN-HG',
      name: 'Phường Hòn Gai',
      type: AdministrativeType.ward,
      parentCode: 'VN-QN',
      aliases: ['TP Hạ Long', 'Hon Gai'],
    ),

    // 8. Tỉnh Cao Bằng
    AdministrativeUnit(
      code: 'VN-CB-SL',
      name: 'Phường Sông Lô',
      type: AdministrativeType.ward,
      parentCode: 'VN-CB',
      aliases: ['TP Cao Bằng', 'Cao Bang'],
    ),
    AdministrativeUnit(
      code: 'VN-CB-HG',
      name: 'Phường Hợp Giang',
      type: AdministrativeType.ward,
      parentCode: 'VN-CB',
      aliases: ['TP Cao Bằng', 'Hop Giang'],
    ),

    // 9. Tỉnh Lạng Sơn
    AdministrativeUnit(
      code: 'VN-LS-VL',
      name: 'Phường Vĩnh Trại',
      type: AdministrativeType.ward,
      parentCode: 'VN-LS',
      aliases: ['TP Lạng Sơn', 'Lang Son', 'Vinh Trai'],
    ),
    AdministrativeUnit(
      code: 'VN-LS-TT',
      name: 'Phường Tam Thanh',
      type: AdministrativeType.ward,
      parentCode: 'VN-LS',
      aliases: ['TP Lạng Sơn', 'Tam Thanh', 'Chùa Tam Thanh'],
    ),

    // 10. Tỉnh Lai Châu
    AdministrativeUnit(
      code: 'VN-LC-DL',
      name: 'Phường Đoàn Kết',
      type: AdministrativeType.ward,
      parentCode: 'VN-LC',
      aliases: ['TP Lai Châu', 'Lai Chau', 'Doan Ket'],
    ),

    // 11. Tỉnh Điện Biên
    AdministrativeUnit(
      code: 'VN-DB-MC',
      name: 'Phường Mường Thanh',
      type: AdministrativeType.ward,
      parentCode: 'VN-DB',
      aliases: ['TP Điện Biên Phủ', 'Dien Bien', 'Muong Thanh'],
    ),

    // 12. Tỉnh Sơn La
    AdministrativeUnit(
      code: 'VN-SL-QL',
      name: 'Phường Quyết Thắng',
      type: AdministrativeType.ward,
      parentCode: 'VN-SL',
      aliases: ['TP Sơn La', 'Son La'],
    ),
    AdministrativeUnit(
      code: 'VN-SL-MC',
      name: 'Thị trấn Mộc Châu',
      type: AdministrativeType.ward,
      parentCode: 'VN-SL',
      aliases: ['Mộc Châu', 'Moc Chau', 'Cao nguyên Mộc Châu'],
    ),

    // 13. Tỉnh Thanh Hóa
    AdministrativeUnit(
      code: 'VN-TH-LB',
      name: 'Phường Lam Sơn',
      type: AdministrativeType.ward,
      parentCode: 'VN-TH',
      aliases: ['TP Thanh Hóa', 'Thanh Hoa', 'Lam Son'],
    ),
    AdministrativeUnit(
      code: 'VN-TH-SS',
      name: 'Phường Trường Sơn',
      type: AdministrativeType.ward,
      parentCode: 'VN-TH',
      aliases: ['TP Sầm Sơn', 'Sam Son', 'Bien Sam Son'],
    ),

    // 14. Tỉnh Nghệ An
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

    // 15. Tỉnh Hà Tĩnh
    AdministrativeUnit(
      code: 'VN-HT-NB',
      name: 'Phường Nam Hà',
      type: AdministrativeType.ward,
      parentCode: 'VN-HT',
      aliases: ['TP Hà Tĩnh', 'Ha Tinh', 'Nam Ha'],
    ),

    // 16. Tỉnh Tuyên Quang
    AdministrativeUnit(
      code: 'VN-TQ-TB',
      name: 'Phường Tân Quang',
      type: AdministrativeType.ward,
      parentCode: 'VN-TQ',
      aliases: ['TP Tuyên Quang', 'Tuyen Quang', 'Tan Quang'],
    ),
    AdministrativeUnit(
      code: 'VN-TQ-HG',
      name: 'Phường Trần Phú',
      type: AdministrativeType.ward,
      parentCode: 'VN-TQ',
      aliases: ['Hà Giang', 'TP Hà Giang', 'Ha Giang'],
    ),

    // 17. Tỉnh Lào Cai
    AdministrativeUnit(
      code: 'VN-LCA-CC',
      name: 'Phường Cốc Lếu',
      type: AdministrativeType.ward,
      parentCode: 'VN-LCA',
      aliases: ['TP Lào Cai', 'Lao Cai', 'Coc Leu'],
    ),
    AdministrativeUnit(
      code: 'VN-LCA-SP',
      name: 'Phường Sa Pa',
      type: AdministrativeType.ward,
      parentCode: 'VN-LCA',
      aliases: ['Thị xã Sa Pa', 'Sapa', 'Sa Pa', 'Fansipan'],
    ),
    AdministrativeUnit(
      code: 'VN-LCA-YB',
      name: 'Phường Đồng Tâm',
      type: AdministrativeType.ward,
      parentCode: 'VN-LCA',
      aliases: ['Yên Bái', 'TP Yên Bái', 'Yen Bai'],
    ),

    // 18. Tỉnh Thái Nguyên
    AdministrativeUnit(
      code: 'VN-TN-PD',
      name: 'Phường Phan Đình Phùng',
      type: AdministrativeType.ward,
      parentCode: 'VN-TN',
      aliases: ['TP Thái Nguyên', 'Thai Nguyen', 'Phan Dinh Phung'],
    ),
    AdministrativeUnit(
      code: 'VN-TN-BK',
      name: 'Phường Phùng Chí Kiên',
      type: AdministrativeType.ward,
      parentCode: 'VN-TN',
      aliases: ['Bắc Kạn', 'TP Bắc Kạn', 'Bac Kan'],
    ),

    // 19. Tỉnh Phú Thọ
    AdministrativeUnit(
      code: 'VN-PT-VT',
      name: 'Phường Gia Cẩm',
      type: AdministrativeType.ward,
      parentCode: 'VN-PT',
      aliases: ['TP Việt Trì', 'Viet Tri', 'Phu Tho', 'Den Hung'],
    ),
    AdministrativeUnit(
      code: 'VN-PT-VP',
      name: 'Phường Khai Quang',
      type: AdministrativeType.ward,
      parentCode: 'VN-PT',
      aliases: ['Vĩnh Phúc', 'TP Vĩnh Yên', 'Vinh Yen', 'Vinh Phuc'],
    ),
    AdministrativeUnit(
      code: 'VN-PT-HB',
      name: 'Phường Phương Lâm',
      type: AdministrativeType.ward,
      parentCode: 'VN-PT',
      aliases: ['Hòa Bình', 'TP Hòa Bình', 'Hoa Binh'],
    ),

    // 20. Tỉnh Bắc Ninh
    AdministrativeUnit(
      code: 'VN-BN-ST',
      name: 'Phường Suối Hoa',
      type: AdministrativeType.ward,
      parentCode: 'VN-BN',
      aliases: ['TP Bắc Ninh', 'Bac Ninh', 'Suoi Hoa'],
    ),
    AdministrativeUnit(
      code: 'VN-BN-BG',
      name: 'Phường Ngô Quyền',
      type: AdministrativeType.ward,
      parentCode: 'VN-BN',
      aliases: ['Bắc Giang', 'TP Bắc Giang', 'Bac Giang'],
    ),

    // 21. Tỉnh Hưng Yên
    AdministrativeUnit(
      code: 'VN-HY-HC',
      name: 'Phường Hiến Nam',
      type: AdministrativeType.ward,
      parentCode: 'VN-HY',
      aliases: ['TP Hưng Yên', 'Hung Yen', 'Pho Hien', 'Hien Nam'],
    ),
    AdministrativeUnit(
      code: 'VN-HY-TB',
      name: 'Phường Lê Hồng Phong',
      type: AdministrativeType.ward,
      parentCode: 'VN-HY',
      aliases: ['Thái Bình', 'TP Thái Bình', 'Thai Binh'],
    ),

    // 22. Tỉnh Ninh Bình
    AdministrativeUnit(
      code: 'VN-NB-VT',
      name: 'Phường Vân Giang',
      type: AdministrativeType.ward,
      parentCode: 'VN-NB',
      aliases: ['TP Ninh Bình', 'Ninh Binh', 'Tràng An', 'Van Giang'],
    ),
    AdministrativeUnit(
      code: 'VN-NB-ND',
      name: 'Phường Vị Xuyên',
      type: AdministrativeType.ward,
      parentCode: 'VN-NB',
      aliases: ['Nam Định', 'TP Nam Định', 'Nam Dinh', 'Vi Xuyen'],
    ),
    AdministrativeUnit(
      code: 'VN-NB-HN',
      name: 'Phường Minh Khai',
      type: AdministrativeType.ward,
      parentCode: 'VN-NB',
      aliases: ['Hà Nam', 'TP Phủ Lý', 'Phu Ly', 'Ha Nam'],
    ),

    // 23. Tỉnh Quảng Trị
    AdministrativeUnit(
      code: 'VN-QT-DH',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-QT',
      aliases: ['TP Đông Hà', 'Dong Ha', 'Quang Tri'],
    ),
    AdministrativeUnit(
      code: 'VN-QT-QB',
      name: 'Phường Đồng Mỹ',
      type: AdministrativeType.ward,
      parentCode: 'VN-QT',
      aliases: ['Quảng Bình', 'TP Đồng Hới', 'Dong Hoi', 'Quang Binh', 'Phong Nha'],
    ),

    // 24. Tỉnh Quảng Ngãi
    AdministrativeUnit(
      code: 'VN-QNG-QN',
      name: 'Phường Trần Phú',
      type: AdministrativeType.ward,
      parentCode: 'VN-QNG',
      aliases: ['TP Quảng Ngãi', 'Quang Ngai', 'Tran Phu'],
    ),
    AdministrativeUnit(
      code: 'VN-QNG-KT',
      name: 'Phường Quyết Thắng',
      type: AdministrativeType.ward,
      parentCode: 'VN-QNG',
      aliases: ['Kon Tum', 'TP Kon Tum', 'Măng Đen', 'Mang Den'],
    ),

    // 25. Tỉnh Gia Lai
    AdministrativeUnit(
      code: 'VN-GL-PK',
      name: 'Phường Diên Hồng',
      type: AdministrativeType.ward,
      parentCode: 'VN-GL',
      aliases: ['TP Pleiku', 'Pleiku', 'Gia Lai', 'Biển Hồ'],
    ),
    AdministrativeUnit(
      code: 'VN-GL-BD',
      name: 'Phường Lê Lợi',
      type: AdministrativeType.ward,
      parentCode: 'VN-GL',
      aliases: ['Bình Định', 'TP Quy Nhơn', 'Quy Nhon', 'Binh Dinh'],
    ),

    // 26. Tỉnh Đắk Lắk
    AdministrativeUnit(
      code: 'VN-DL-BM',
      name: 'Phường Thắng Lợi',
      type: AdministrativeType.ward,
      parentCode: 'VN-DL',
      aliases: ['TP Buôn Ma Thuột', 'Buon Ma Thuot', 'BMT', 'Dak Lak'],
    ),
    AdministrativeUnit(
      code: 'VN-DL-PY',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-DL',
      aliases: ['Phú Yên', 'TP Tuy Hòa', 'Tuy Hoa', 'Phu Yen'],
    ),

    // 27. Tỉnh Khánh Hòa
    AdministrativeUnit(
      code: 'VN-KH-NT',
      name: 'Phường Lộc Thọ',
      type: AdministrativeType.ward,
      parentCode: 'VN-KH',
      aliases: ['TP Nha Trang', 'Nha Trang', 'Loc Tho', 'Bien Nha Trang'],
    ),
    AdministrativeUnit(
      code: 'VN-KH-PR',
      name: 'Phường Thanh Sơn',
      type: AdministrativeType.ward,
      parentCode: 'VN-KH',
      aliases: ['Ninh Thuận', 'TP Phan Rang - Tháp Chàm', 'Phan Rang', 'Ninh Thuan'],
    ),

    // 28. Tỉnh Lâm Đồng
    AdministrativeUnit(
      code: 'VN-LD-DL',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-LD',
      aliases: ['TP Đà Lạt', 'Da Lat', 'Dalat', 'Hồ Xuân Hương', 'Lam Dong'],
    ),
    AdministrativeUnit(
      code: 'VN-LD-DN',
      name: 'Phường Nghĩa Đức',
      type: AdministrativeType.ward,
      parentCode: 'VN-LD',
      aliases: ['Đắk Nông', 'TP Gia Nghĩa', 'Gia Nghia', 'Dak Nong'],
    ),
    AdministrativeUnit(
      code: 'VN-LD-BT',
      name: 'Phường Mũi Né',
      type: AdministrativeType.ward,
      parentCode: 'VN-LD',
      aliases: ['Bình Thuận', 'TP Phan Thiết', 'Phan Thiet', 'Mũi Né', 'Mui Ne', 'Binh Thuan'],
    ),

    // 29. Tỉnh Đồng Nai
    // --- Thành phố Biên Hòa ---
    AdministrativeUnit(
      code: 'VN-39-BH',
      name: 'Phường Trung Dũng',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Trung Dung'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LH',
      name: 'Xã Long Hưng',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Long Hung', 'Aqua City'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-QT',
      name: 'Phường Quyết Thắng',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Quyet Thang', 'Ga Bien Hoa'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-TN',
      name: 'Phường Thống Nhất',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Thong Nhat', 'Duong Vo Thi Sau'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-TP',
      name: 'Phường Tân Phong',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Tan Phong'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-TD',
      name: 'Phường Trảng Dài',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Trang Dai'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-TH',
      name: 'Phường Tam Hiệp',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Tam Hiep'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-TM',
      name: 'Phường Tân Mai',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Tan Mai'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-HN',
      name: 'Phường Hố Nai',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Ho Nai'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-BL',
      name: 'Phường Bửu Long',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Buu Long', 'Khu du lich Buu Long'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-HA',
      name: 'Phường Hóa An',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'Hoa An'],
    ),
    AdministrativeUnit(
      code: 'VN-39-BH-AB',
      name: 'Phường An Bình',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Biên Hòa',
      aliases: ['Bien Hoa', 'An Binh', 'KCN Bien Hoa 1'],
    ),

    // --- Thành phố Long Khánh ---
    AdministrativeUnit(
      code: 'VN-39-LK-XA',
      name: 'Phường Xuân An',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Long Khánh',
      aliases: ['TP Long Khanh', 'Long Khanh', 'Xuan An'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LK-XB',
      name: 'Phường Xuân Bình',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Long Khánh',
      aliases: ['TP Long Khanh', 'Long Khanh', 'Xuan Binh'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LK-XH',
      name: 'Phường Xuân Hòa',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Long Khánh',
      aliases: ['TP Long Khanh', 'Long Khanh', 'Xuan Hoa'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LK-PB',
      name: 'Phường Phú Bình',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Long Khánh',
      aliases: ['TP Long Khanh', 'Long Khanh', 'Phu Binh'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LK-ST',
      name: 'Phường Suối Tre',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Thành phố Long Khánh',
      aliases: ['TP Long Khanh', 'Long Khanh', 'Suoi Tre'],
    ),

    // --- Huyện Long Thành ---
    AdministrativeUnit(
      code: 'VN-39-LT-TT',
      name: 'Thị trấn Long Thành',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Long Thành',
      aliases: ['Long Thanh', 'Thi tran Long Thanh'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LT-BS',
      name: 'Xã Bình Sơn',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Long Thành',
      aliases: ['Long Thanh', 'Binh Son', 'San bay Quoc te Long Thanh', 'San bay Long Thanh'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LT-AP',
      name: 'Xã An Phước',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Long Thành',
      aliases: ['Long Thanh', 'An Phuoc'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LT-LA',
      name: 'Xã Lộc An',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Long Thành',
      aliases: ['Long Thanh', 'Loc An'],
    ),
    AdministrativeUnit(
      code: 'VN-39-LT-PT',
      name: 'Xã Phước Thái',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Long Thành',
      aliases: ['Long Thanh', 'Phuoc Thai'],
    ),

    // --- Huyện Nhơn Trạch ---
    AdministrativeUnit(
      code: 'VN-39-NT-HP',
      name: 'Thị trấn Hiệp Phước',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Nhơn Trạch',
      aliases: ['Nhon Trach', 'Hiep Phuoc'],
    ),
    AdministrativeUnit(
      code: 'VN-39-NT-PH',
      name: 'Xã Phú Hội',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Nhơn Trạch',
      aliases: ['Nhon Trach', 'Phu Hoi'],
    ),
    AdministrativeUnit(
      code: 'VN-39-NT-PT',
      name: 'Xã Phước Thiền',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Nhơn Trạch',
      aliases: ['Nhon Trach', 'Phuoc Thien'],
    ),
    AdministrativeUnit(
      code: 'VN-39-NT-DP',
      name: 'Xã Đại Phước',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Nhơn Trạch',
      aliases: ['Nhon Trach', 'Dai Phuoc', 'Dao SwanBay'],
    ),

    // --- Huyện Trảng Bom ---
    AdministrativeUnit(
      code: 'VN-39-TB-TT',
      name: 'Thị trấn Trảng Bom',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Trảng Bom',
      aliases: ['Trang Bom', 'Thi tran Trang Bom'],
    ),
    AdministrativeUnit(
      code: 'VN-39-TB-HN',
      name: 'Xã Hố Nai 3',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Trảng Bom',
      aliases: ['Trang Bom', 'Ho Nai 3'],
    ),
    AdministrativeUnit(
      code: 'VN-39-TB-BS',
      name: 'Xã Bắc Sơn',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Trảng Bom',
      aliases: ['Trang Bom', 'Bac Son'],
    ),
    AdministrativeUnit(
      code: 'VN-39-TB-ST',
      name: 'Xã Sông Trầu',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Trảng Bom',
      aliases: ['Trang Bom', 'Song Trau'],
    ),

    // --- Huyện Vĩnh Cửu ---
    AdministrativeUnit(
      code: 'VN-39-VC-VA',
      name: 'Thị trấn Vĩnh An',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Vĩnh Cửu',
      aliases: ['Vinh Cuu', 'Vinh An', 'Ho Tri An'],
    ),
    AdministrativeUnit(
      code: 'VN-39-VC-TP',
      name: 'Xã Thạnh Phú',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Vĩnh Cửu',
      aliases: ['Vinh Cuu', 'Thanh Phu'],
    ),

    // --- Huyện Thống Nhất ---
    AdministrativeUnit(
      code: 'VN-39-TN-DG',
      name: 'Thị trấn Dầu Giây',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Thống Nhất',
      aliases: ['Thong Nhat', 'Dau Giay', 'Nga 3 Dau Giay'],
    ),
    AdministrativeUnit(
      code: 'VN-39-TN-GK',
      name: 'Xã Gia Kiệm',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Thống Nhất',
      aliases: ['Thong Nhat', 'Gia Kiem'],
    ),

    // --- Huyện Xuân Lộc ---
    AdministrativeUnit(
      code: 'VN-39-XL-GR',
      name: 'Thị trấn Gia Ray',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Xuân Lộc',
      aliases: ['Xuan Loc', 'Gia Ray', 'Nui Chua Chan'],
    ),
    AdministrativeUnit(
      code: 'VN-39-XL-SC',
      name: 'Xã Suối Cát',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Xuân Lộc',
      aliases: ['Xuan Loc', 'Suoi Cat'],
    ),

    // --- Huyện Định Quán ---
    AdministrativeUnit(
      code: 'VN-39-DQ-TT',
      name: 'Thị trấn Định Quán',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Định Quán',
      aliases: ['Dinh Quan', 'Thi tran Dinh Quan'],
    ),
    AdministrativeUnit(
      code: 'VN-39-DQ-LN',
      name: 'Xã La Ngà',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Định Quán',
      aliases: ['Dinh Quan', 'La Nga'],
    ),

    // --- Huyện Tân Phú (Đồng Nai) ---
    AdministrativeUnit(
      code: 'VN-39-TP-TT',
      name: 'Thị trấn Tân Phú',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Tân Phú',
      aliases: ['Tan Phu Dong Nai', 'Thi tran Tan Phu'],
    ),
    AdministrativeUnit(
      code: 'VN-39-TP-CT',
      name: 'Xã Nam Cát Tiên',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Tân Phú',
      aliases: ['Tan Phu Dong Nai', 'Nam Cat Tiên', 'Vuon Quoc gia Cat Tien'],
    ),

    // --- Huyện Cẩm Mỹ ---
    AdministrativeUnit(
      code: 'VN-39-CM-LG',
      name: 'Thị trấn Long Giao',
      type: AdministrativeType.ward,
      parentCode: 'VN-39',
      districtName: 'Huyện Cẩm Mỹ',
      aliases: ['Cam My', 'Long Giao'],
    ),

    // 30. Tỉnh Tây Ninh
    AdministrativeUnit(
      code: 'VN-TNI-TN',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-TNI',
      aliases: ['TP Tây Ninh', 'Tay Ninh', 'Núi Bà Đen'],
    ),
    AdministrativeUnit(
      code: 'VN-TNI-LA',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-TNI',
      aliases: ['Long An', 'TP Tân An', 'Tan An', 'Long An'],
    ),

    // 31. Tỉnh Đồng Tháp
    AdministrativeUnit(
      code: 'VN-DT-CL',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-DT',
      aliases: ['TP Cao Lãnh', 'Cao Lanh', 'Dong Thap'],
    ),
    AdministrativeUnit(
      code: 'VN-DT-TG',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-DT',
      aliases: ['Tiền Giang', 'TP Mỹ Tho', 'My Tho', 'Tien Giang'],
    ),

    // 32. Tỉnh Vĩnh Long
    AdministrativeUnit(
      code: 'VN-VL-VL',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-VL',
      aliases: ['TP Vĩnh Long', 'Vinh Long'],
    ),
    AdministrativeUnit(
      code: 'VN-VL-BT',
      name: 'Phường An Hội',
      type: AdministrativeType.ward,
      parentCode: 'VN-VL',
      aliases: ['Bến Tre', 'TP Bến Tre', 'Ben Tre'],
    ),
    AdministrativeUnit(
      code: 'VN-VL-TV',
      name: 'Phường 1',
      type: AdministrativeType.ward,
      parentCode: 'VN-VL',
      aliases: ['Trà Vinh', 'TP Trà Vinh', 'Tra Vinh'],
    ),

    // 33. Tỉnh An Giang
    AdministrativeUnit(
      code: 'VN-AG-LX',
      name: 'Phường Mỹ Bình',
      type: AdministrativeType.ward,
      parentCode: 'VN-AG',
      aliases: ['TP Long Xuyên', 'Long Xuyen', 'An Giang'],
    ),
    AdministrativeUnit(
      code: 'VN-AG-CD',
      name: 'Phường Châu Phú A',
      type: AdministrativeType.ward,
      parentCode: 'VN-AG',
      aliases: ['TP Châu Đốc', 'Chau Doc', 'Miếu Bà Chúa Xứ'],
    ),
    AdministrativeUnit(
      code: 'VN-AG-PQ',
      name: 'Phường Dương Đông',
      type: AdministrativeType.ward,
      parentCode: 'VN-AG',
      aliases: [
        'Kiên Giang',
        'TP Phú Quốc',
        'Phú Quốc',
        'Phu Quoc',
        'Đặc khu Phú Quốc',
        'Kien Giang',
        'Rạch Giá',
      ],
    ),

    // 34. Tỉnh Cà Mau
    AdministrativeUnit(
      code: 'VN-CM-CM',
      name: 'Phường 5',
      type: AdministrativeType.ward,
      parentCode: 'VN-CM',
      aliases: ['TP Cà Mau', 'Ca Mau', 'Đất Mũi'],
    ),
    AdministrativeUnit(
      code: 'VN-CM-BL',
      name: 'Phường 3',
      type: AdministrativeType.ward,
      parentCode: 'VN-CM',
      aliases: ['Bạc Liêu', 'TP Bạc Liêu', 'Bac Lieu', 'Nhà Công tử Bạc Liêu'],
    ),
  ];

  @override
  Future<List<AdministrativeUnit>> getProvinces({String? query}) async {
    // Trả về ngay danh sách (tách biệt hoàn toàn khỏi Spa data, hỗ trợ filter in-memory)
    if (query == null || query.trim().isEmpty) {
      return List.unmodifiable(_provinces);
    }
    return _provinces.where((p) => p.matchesQuery(query)).toList();
  }

  @override
  Future<List<AdministrativeUnit>> getWards(String provinceCode, {String? query}) async {
    final wardsOfProvince = _wards.where((w) => w.parentCode == provinceCode).toList();
    if (query == null || query.trim().isEmpty) {
      return wardsOfProvince;
    }
    return wardsOfProvince.where((w) => w.matchesQuery(query)).toList();
  }

  @override
  AdministrativeUnit? getProvinceByCode(String code) {
    try {
      return _provinces.firstWhere((p) => p.code == code);
    } catch (_) {
      return null;
    }
  }

  @override
  AdministrativeUnit? getWardByCode(String code) {
    try {
      return _wards.firstWhere((w) => w.code == code);
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
    if (ward?.districtName != null) {
      return '$wardName, ${ward!.districtName}, $provinceName';
    }
    return '$wardName, $provinceName';
  }
}
