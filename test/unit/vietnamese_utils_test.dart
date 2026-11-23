import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/core/utils/vietnamese_utils.dart';

void main() {
  group('VietnameseUtils Test Suite', () {
    test('Chuyển chuỗi tiếng Việt có dấu sang không dấu', () {
      expect(
        VietnameseUtils.toNonDiacritic('Gội đầu dưỡng sinh'),
        equals('goi dau duong sinh'),
      );
      expect(
        VietnameseUtils.toNonDiacritic('Đà Nẵng & TP. Hồ Chí Minh'),
        equals('da nang & tp. ho chi minh'),
      );
    });

    test('Tìm kiếm không phân biệt chữ hoa, chữ thường và dấu tiếng Việt', () {
      const source = 'Gội đầu dưỡng sinh 60 phút';

      // 1. Nhập "gội đầu" tìm thấy dịch vụ liên quan
      expect(VietnameseUtils.containsSearch(source, 'gội đầu'), isTrue);

      // 2. Nhập "goi dau" vẫn tìm thấy dịch vụ có dấu
      expect(VietnameseUtils.containsSearch(source, 'goi dau'), isTrue);

      // 3. Không phân biệt chữ hoa và chữ thường
      expect(VietnameseUtils.containsSearch(source, 'GỘI ĐẦU'), isTrue);
      expect(VietnameseUtils.containsSearch(source, 'GOI DAU'), isTrue);

      // Kiểm tra từ khóa không khớp
      expect(VietnameseUtils.containsSearch(source, 'massage'), isFalse);
    });

    test('Chuẩn hoá khoảng trắng dư thừa', () {
      expect(
        VietnameseUtils.normalize('  Gội   đầu   dưỡng sinh   '),
        equals('goi dau duong sinh'),
      );
      expect(
        VietnameseUtils.containsSearch('Gội đầu dưỡng sinh', '  goi   dau  '),
        isTrue,
      );
    });
  });
}
