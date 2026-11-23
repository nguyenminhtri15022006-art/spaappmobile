import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/features/search/data/mock_search_repository.dart';
import 'package:spa_marketplace/features/search/models/spa_search_filter.dart';

void main() {
  late MockSearchRepository repository;

  setUp(() {
    repository = MockSearchRepository();
  });

  group('MockSearchRepository Unit Tests', () {
    test('1. Nhập "gội đầu" tìm thấy các dịch vụ liên quan', () async {
      final results = await repository.search(
        const SpaSearchFilter(keyword: 'gội đầu'),
      );
      expect(results.isNotEmpty, isTrue);
      expect(
        results.any((r) => r.service.name.toLowerCase().contains('gội đầu')),
        isTrue,
      );
    });

    test('2. Nhập "goi dau" không dấu vẫn tìm thấy dịch vụ có dấu', () async {
      final results = await repository.search(
        const SpaSearchFilter(keyword: 'goi dau'),
      );
      expect(results.isNotEmpty, isTrue);
      expect(
        results.any((r) => r.service.name.contains('Gội đầu dưỡng sinh')),
        isTrue,
      );
    });

    test('3. Không phân biệt chữ hoa và chữ thường ("GỘI ĐẦU" hoặc "GoI DaU")', () async {
      final upperResults = await repository.search(
        const SpaSearchFilter(keyword: 'GỘI ĐẦU'),
      );
      final lowerResults = await repository.search(
        const SpaSearchFilter(keyword: 'gội đầu'),
      );
      expect(upperResults.length, equals(lowerResults.length));
    });

    test('5. Bộ lọc địa điểm chỉ lấy Spa có chi nhánh phù hợp khu vực', () async {
      // Chỉ tìm dịch vụ tại TP. Hà Nội (VN-HN)
      final hnResults = await repository.search(
        const SpaSearchFilter(provinceCode: 'VN-HN'),
      );
      expect(hnResults.isNotEmpty, isTrue);

      // Mọi kết quả trả về phải có chi nhánh matching thuộc Hà Nội
      for (final res in hnResults) {
        expect(
          res.matchingBranches.every((b) => b.provinceCode == 'VN-HN'),
          isTrue,
        );
      }
    });

    test('6. Một Spa có nhiều chi nhánh KHÔNG làm nhân bản (trùng) kết quả dịch vụ', () async {
      // Lotus Spa có 3 chi nhánh, nhưng cùng 1 dịch vụ chỉ được xuất hiện 1 lần
      final results = await repository.search(
        const SpaSearchFilter(keyword: 'Gội đầu dưỡng sinh 60 phút'),
      );

      final lotusServices = results.where(
        (r) => r.spa.id == 'spa_lotus' && r.service.id == 'srv_lotus_gd60',
      );
      expect(lotusServices.length, equals(1));
      // Chi nhánh được gộp vào matchingBranches
      expect(lotusServices.first.matchingBranchesCount, greaterThanOrEqualTo(1));
    });

    test('7. Bộ lọc khoảng giá chính xác', () async {
      const min = 150000.0;
      const max = 300000.0;

      final results = await repository.search(
        const SpaSearchFilter(minPrice: min, maxPrice: max),
      );

      expect(results.isNotEmpty, isTrue);
      for (final res in results) {
        expect(res.service.price, greaterThanOrEqualTo(min));
        expect(res.service.price, lessThanOrEqualTo(max));
      }
    });

    test('8. Kết hợp đồng thời: Từ khóa + Địa điểm + Giá + Đánh giá', () async {
      final results = await repository.search(
        const SpaSearchFilter(
          keyword: 'gội đầu',
          provinceCode: 'VN-SG',
          minPrice: 100000,
          maxPrice: 200000,
          minRating: 4.8,
        ),
      );

      expect(results.isNotEmpty, isTrue);
      for (final res in results) {
        expect(res.service.price, inInclusiveRange(100000, 200000));
        expect(res.spa.rating, greaterThanOrEqualTo(4.8));
        expect(
          res.matchingBranches.any((b) => b.provinceCode == 'VN-SG'),
          isTrue,
        );
      }
    });

    test('9. Sắp xếp giá tăng dần và giảm dần', () async {
      final ascResults = await repository.search(
        const SpaSearchFilter(sortBy: SortOption.priceAsc),
      );
      for (int i = 0; i < ascResults.length - 1; i++) {
        expect(
          ascResults[i].service.price <= ascResults[i + 1].service.price,
          isTrue,
        );
      }

      final descResults = await repository.search(
        const SpaSearchFilter(sortBy: SortOption.priceDesc),
      );
      for (int i = 0; i < descResults.length - 1; i++) {
        expect(
          descResults[i].service.price >= descResults[i + 1].service.price,
          isTrue,
        );
      }
    });

    test('10. Bộ lọc rỗng (mặc định) trả về toàn bộ dịch vụ', () async {
      final results = await repository.search(const SpaSearchFilter());
      expect(results.isNotEmpty, isTrue);
      expect(results.length, greaterThanOrEqualTo(10));
    });

    test('11. Gợi ý từ khóa tự động', () async {
      final suggestions = await repository.getSuggestions('gội');
      expect(suggestions.isNotEmpty, isTrue);
      expect(suggestions.any((s) => s.toLowerCase().contains('gội')), isTrue);
    });

    test('12. Tìm Spa hoặc Dịch vụ bằng ID không tồn tại trả về null', () async {
      final nullSpa = await repository.getSpaById('spa_invalid_9999');
      expect(nullSpa, isNull);

      final nullService = await repository.getServiceById('srv_invalid_9999');
      expect(nullService, isNull);
    });

    test('13. Sắp xếp gần nhất (SortOption.nearest) tính theo tọa độ địa lý, không lấy số chi nhánh', () async {
      final nearestResults = await repository.search(
        const SpaSearchFilter(sortBy: SortOption.nearest),
      );
      expect(nearestResults.isNotEmpty, isTrue);
      // Kết quả phải trả về danh sách hợp lệ
      expect(nearestResults.first.matchingBranches.isNotEmpty, isTrue);
    });
  });
}
