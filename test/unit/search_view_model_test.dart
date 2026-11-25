import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/features/search/data/mock_search_repository.dart';
import 'package:spa_marketplace/features/search/models/spa_search_filter.dart';
import 'package:spa_marketplace/features/search/presentation/view_models/search_state.dart';
import 'package:spa_marketplace/features/search/presentation/view_models/search_view_model.dart';
import 'package:spa_marketplace/shared/data/mock_administrative_repository.dart';

void main() {
  late MockSearchRepository repository;
  late SearchViewModel viewModel;

  setUp(() {
    repository = MockSearchRepository();
    viewModel = SearchViewModel(repository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('SearchViewModel State Tests', () {
    test('Chọn tỉnh/thành mới thì xã/phường cũ BẮT BUỘC được reset', () {
      viewModel.openFilterSheet();

      // Chọn tỉnh TP.HCM và phường Bến Nghé
      viewModel.updateDraftProvince('VN-SG');
      viewModel.updateDraftWard('VN-SG-BN');
      expect(viewModel.state.draftFilter.provinceCode, equals('VN-SG'));
      expect(viewModel.state.draftFilter.wardCode, equals('VN-SG-BN'));

      // Khi người dùng chuyển sang Hà Nội (VN-HN), phường Bến Nghé phải bị xóa
      viewModel.updateDraftProvince('VN-HN');
      expect(viewModel.state.draftFilter.provinceCode, equals('VN-HN'));
      expect(viewModel.state.draftFilter.wardCode, isNull);
    });

    test('Không thể chọn xã/phường nếu chưa chọn tỉnh/thành tương ứng', () {
      viewModel.openFilterSheet();

      // Chưa chọn tỉnh mà chọn phường
      expect(viewModel.state.draftFilter.provinceCode, isNull);
      viewModel.updateDraftWard('VN-SG-BN');

      // Phường không được phép cập nhật
      expect(viewModel.state.draftFilter.wardCode, isNull);
    });

    test('Cập nhật mốc Demo và bán kính khoảng cách', () {
      viewModel.openFilterSheet();

      // Mặc định là DemoLocation.none -> không thể chọn bán kính
      viewModel.updateDraftDistance(5.0);
      expect(viewModel.state.draftFilter.maxDistanceKm, isNull);

      // Chọn mốc Demo Bến Thành
      viewModel.updateDraftDemoLocation(DemoLocation.benThanh);
      expect(viewModel.state.draftFilter.demoLocation, equals(DemoLocation.benThanh));

      // Giờ có thể chọn bán kính 5km
      viewModel.updateDraftDistance(5.0);
      expect(viewModel.state.draftFilter.maxDistanceKm, equals(5.0));

      // Nếu chuyển về DemoLocation.none (chờ GPS thật) thì khoảng cách bị xóa
      viewModel.updateDraftDemoLocation(DemoLocation.none);
      expect(viewModel.state.draftFilter.maxDistanceKm, isNull);
    });

    test('DraftFilter tách biệt với AppliedFilter cho đến khi bấm Áp dụng', () {
      viewModel.openFilterSheet();

      // Chỉnh sửa trong draft
      viewModel.updateDraftPriceRange(100000, 300000);
      expect(viewModel.state.draftFilter.minPrice, equals(100000));
      // AppliedFilter vẫn giữ nguyên giá trị ban đầu
      expect(viewModel.state.appliedFilter.minPrice, equals(SpaSearchFilter.defaultMinPrice));

      // Bấm Áp dụng
      viewModel.applyDraftFilter();
      expect(viewModel.state.appliedFilter.minPrice, equals(100000));
    });

    test('Đặt lại bộ lọc (Reset) giữ lại từ khóa tìm kiếm', () {
      viewModel.onQueryChanged('gội đầu');
      viewModel.openFilterSheet();
      viewModel.updateDraftProvince('VN-SG');
      viewModel.updateDraftRating(4.5);

      viewModel.resetDraftFilter(keepKeyword: true);
      expect(viewModel.state.draftFilter.provinceCode, isNull);
      expect(viewModel.state.draftFilter.minRating, isNull);
      expect(viewModel.state.draftFilter.keyword, equals('gội đầu'));
    });

    test('Kết quả không tìm thấy hiển thị SearchStatus.empty', () async {
      await viewModel.submitSearch('dịch vụ không hề tồn tại xyz 999');
      expect(viewModel.state.status, equals(SearchStatus.empty));
      expect(viewModel.state.results.isEmpty, isTrue);
    });

    test('Tìm kiếm thành công trả về SearchStatus.success', () async {
      await viewModel.submitSearch('Gội đầu');
      expect(viewModel.state.status, equals(SearchStatus.success));
      expect(viewModel.state.results.isNotEmpty, isTrue);
    });

    test('Quick Filter: Áp dụng và xóa riêng từng bộ lọc (Category, Rating, Price, Location, Sort)', () async {
      // 1. Áp dụng Quick Category
      await viewModel.applyQuickCategory('cat_goidau');
      expect(viewModel.state.appliedFilter.categoryId, equals('cat_goidau'));
      expect(viewModel.state.draftFilter.categoryId, equals('cat_goidau'));

      // 2. Áp dụng Quick Rating
      await viewModel.applyQuickRating(4.5);
      expect(viewModel.state.appliedFilter.minRating, equals(4.5));
      // Giữ nguyên category đã chọn trước đó
      expect(viewModel.state.appliedFilter.categoryId, equals('cat_goidau'));

      // 3. Áp dụng Quick Price
      await viewModel.applyQuickPrice(100000, 400000);
      expect(viewModel.state.appliedFilter.minPrice, equals(100000));
      expect(viewModel.state.appliedFilter.maxPrice, equals(400000));

      // 4. Áp dụng Quick Location
      await viewModel.applyQuickLocation('VN-SG', 'VN-SG-BN');
      expect(viewModel.state.appliedFilter.provinceCode, equals('VN-SG'));
      expect(viewModel.state.appliedFilter.wardCode, equals('VN-SG-BN'));

      // 5. Áp dụng Quick Sort
      await viewModel.applyQuickSort(SortOption.priceAsc);
      expect(viewModel.state.appliedFilter.sortBy, equals(SortOption.priceAsc));

      // 6. Xóa riêng từng bộ lọc (Reset Category mà không ảnh hưởng Rating, Price, Location)
      await viewModel.applyQuickCategory(null);
      expect(viewModel.state.appliedFilter.categoryId, isNull);
      expect(viewModel.state.appliedFilter.minRating, equals(4.5));
      expect(viewModel.state.appliedFilter.provinceCode, equals('VN-SG'));

      // 7. Xóa riêng Rating
      await viewModel.applyQuickRating(null);
      expect(viewModel.state.appliedFilter.minRating, isNull);
      expect(viewModel.state.appliedFilter.provinceCode, equals('VN-SG'));
    });

    test('Đồng bộ 1 nguồn State giữa Quick Filter và Bộ lọc nâng cao (Single Source of Truth)', () async {
      // Chọn từ Quick Filter
      await viewModel.applyQuickCategory('cat_massage');
      await viewModel.applyQuickRating(4.0);

      // Mở bộ lọc nâng cao
      viewModel.openFilterSheet();

      // DraftFilter phải được đồng bộ chính xác từ AppliedFilter
      expect(viewModel.state.draftFilter.categoryId, equals('cat_massage'));
      expect(viewModel.state.draftFilter.minRating, equals(4.0));
    });

    test('Tìm kiếm tiếng Việt có dấu và không dấu trả về kết quả tương đương', () async {
      final resWithDiacritics = await repository.search(const SpaSearchFilter(keyword: 'gội đầu'));
      final resWithoutDiacritics = await repository.search(const SpaSearchFilter(keyword: 'goi dau'));
      final resUpperCase = await repository.search(const SpaSearchFilter(keyword: 'GỘI ĐẦU'));

      expect(resWithDiacritics.isNotEmpty, isTrue);
      expect(resWithoutDiacritics.length, equals(resWithDiacritics.length));
      expect(resUpperCase.length, equals(resWithDiacritics.length));
    });

    test('Dữ liệu hành chính chuẩn toàn quốc (63 tỉnh/thành, quận/huyện, xã/phường) nạp từ JSON', () async {
      final adminRepo = MockAdministrativeRepository();
      final allProvinces = await adminRepo.getProvinces();

      // Kiểm tra đầy đủ 63 đơn vị hành chính cấp tỉnh
      expect(allProvinces.length, equals(63));

      // Kiểm tra tìm kiếm không dấu
      final hcm = await adminRepo.getProvinces(query: 'ho chi minh');
      expect(hcm.any((p) => p.code == 'VN-SG'), isTrue);

      // Kiểm tra tìm kiếm tỉnh độc lập (Bình Dương, Quảng Bình)
      final binhDuong = await adminRepo.getProvinces(query: 'binh duong');
      expect(binhDuong.any((p) => p.name.contains('Bình Dương')), isTrue);

      final quangBinh = await adminRepo.getProvinces(query: 'quang binh');
      expect(quangBinh.any((p) => p.name.contains('Quảng Bình')), isTrue);

      // Kiểm tra tìm kiếm phường xã của Nghệ An
      final ngheAnWards = await adminRepo.getWards('VN-22');
      expect(ngheAnWards.isNotEmpty, isTrue);
      expect(ngheAnWards.any((w) => w.code == 'VN-22-TT'), isTrue);

      // Tìm kiếm phường theo quận (Quận 1)
      final sgWards = await adminRepo.getWards('VN-SG', query: 'quan 1');
      expect(sgWards.any((w) => w.name == 'Phường Bến Nghé'), isTrue);
    });
  });
}
