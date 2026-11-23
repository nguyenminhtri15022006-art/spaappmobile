import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/features/search/data/mock_search_repository.dart';
import 'package:spa_marketplace/features/search/models/spa_search_filter.dart';
import 'package:spa_marketplace/features/search/presentation/view_models/search_state.dart';
import 'package:spa_marketplace/features/search/presentation/view_models/search_view_model.dart';

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
  });
}
