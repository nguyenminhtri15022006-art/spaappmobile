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
    test('4. Chọn tỉnh/thành mới thì xã/phường cũ BẮT BUỘC được reset', () {
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

    test('11. Kết quả không tìm thấy hiển thị SearchStatus.empty', () async {
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
