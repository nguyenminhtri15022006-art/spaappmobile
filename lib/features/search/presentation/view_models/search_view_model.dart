import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/debouncer.dart';
import '../../data/mock_search_repository.dart';
import '../../data/search_repository.dart';
import '../../models/spa_search_filter.dart';
import 'search_state.dart';
import '../../../../shared/data/mock_administrative_repository.dart';

// Providers
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return MockSearchRepository();
});

final administrativeRepositoryProvider = Provider<AdministrativeRepository>((ref) {
  return MockAdministrativeRepository();
});

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchViewModel(repository);
});

class SearchViewModel extends StateNotifier<SearchState> {
  final SearchRepository _repository;
  final Debouncer _suggestionDebouncer;

  SearchViewModel(
    this._repository, {
    Debouncer? debouncer,
  })  : _suggestionDebouncer = debouncer ?? Debouncer(delay: const Duration(milliseconds: 300)),
        super(const SearchState()) {
    // Tải kết quả khởi tạo (các dịch vụ nổi bật khi mới mở tìm kiếm)
    loadInitialServices();
  }

  /// Tải các dịch vụ mặc định khi mở màn hình
  Future<void> loadInitialServices() async {
    state = state.copyWith(status: SearchStatus.loading);
    try {
      final results = await _repository.search(state.appliedFilter);
      state = state.copyWith(
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Đã có lỗi xảy ra khi tải dịch vụ. Vui lòng thử lại.',
      );
    }
  }

  /// Khi người dùng gõ từ khóa trên ô tìm kiếm
  void onQueryChanged(String query) {
    state = state.copyWith(
      query: query,
      isSuggestionsVisible: query.trim().isNotEmpty,
    );

    _suggestionDebouncer.run(() async {
      try {
        final suggestions = await _repository.getSuggestions(query);
        state = state.copyWith(suggestions: suggestions);
      } catch (_) {
        state = state.copyWith(suggestions: []);
      }
    });
  }

  /// Thực hiện tìm kiếm (nhấn Enter hoặc bấm icon Search)
  Future<void> submitSearch([String? newQuery]) async {
    final effectiveQuery = (newQuery ?? state.query).trim();
    _suggestionDebouncer.cancel();

    final updatedFilter = state.appliedFilter.copyWith(keyword: effectiveQuery);

    state = state.copyWith(
      query: effectiveQuery,
      appliedFilter: updatedFilter,
      draftFilter: updatedFilter,
      status: SearchStatus.loading,
      isSuggestionsVisible: false,
      clearError: true,
    );

    try {
      final results = await _repository.search(updatedFilter);
      state = state.copyWith(
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Không thể tìm kiếm lúc này. Vui lòng thử lại.',
      );
    }
  }

  /// Chọn một từ khoá gợi ý
  void selectSuggestion(String suggestion) {
    state = state.copyWith(query: suggestion);
    submitSearch(suggestion);
  }

  /// Xóa toàn bộ nội dung ô tìm kiếm
  void clearQuery() {
    state = state.copyWith(
      query: '',
      isSuggestionsVisible: false,
      suggestions: [],
    );
    submitSearch('');
  }

  /// Ẩn overlay gợi ý
  void hideSuggestions() {
    state = state.copyWith(isSuggestionsVisible: false);
  }

  // ===================== QUẢN LÝ DRAFT FILTER =====================

  /// Cập nhật trực tiếp toàn bộ DraftFilter
  void updateDraftFilter(SpaSearchFilter filter) {
    state = state.copyWith(draftFilter: filter);
  }

  /// Mở Bottom Sheet: Đồng bộ DraftFilter từ AppliedFilter hiện tại
  void openFilterSheet() {
    state = state.copyWith(
      draftFilter: state.appliedFilter,
      isSuggestionsVisible: false,
    );
  }

  /// Cập nhật Tỉnh/Thành phố trong Draft
  /// LƯU Ý QUAN TRỌNG: Đổi tỉnh/thành phải tự động RESET Xã/Phường đã chọn!
  void updateDraftProvince(String? provinceCode) {
    final updated = state.draftFilter.copyWith(
      provinceCode: provinceCode,
      clearProvince: provinceCode == null,
      clearWard: true, // Reset phường xã ngay lập tức
    );
    state = state.copyWith(draftFilter: updated);
  }

  /// Cập nhật Xã/Phường trong Draft
  void updateDraftWard(String? wardCode) {
    final updated = state.draftFilter.copyWith(
      wardCode: wardCode,
      clearWard: wardCode == null,
    );
    state = state.copyWith(draftFilter: updated);
  }

  /// Cập nhật Danh mục trong Draft
  void updateDraftCategory(String? categoryId) {
    final isSelected = state.draftFilter.categoryId == categoryId;
    final updated = state.draftFilter.copyWith(
      categoryId: isSelected ? null : categoryId,
      clearCategory: isSelected,
    );
    state = state.copyWith(draftFilter: updated);
  }

  /// Cập nhật Khoảng giá trong Draft
  void updateDraftPriceRange(double min, double max) {
    final validMin = min < max ? min : max;
    final validMax = max > min ? max : min;
    final updated = state.draftFilter.copyWith(
      minPrice: validMin,
      maxPrice: validMax,
    );
    state = state.copyWith(draftFilter: updated);
  }

  /// Cập nhật Đánh giá tối thiểu trong Draft
  void updateDraftRating(double? minRating) {
    final isSame = state.draftFilter.minRating == minRating;
    final updated = state.draftFilter.copyWith(
      minRating: isSame ? null : minRating,
      clearMinRating: isSame,
    );
    state = state.copyWith(draftFilter: updated);
  }

  /// Cập nhật Thời lượng trong Draft
  void updateDraftDuration(int? min, int? max) {
    final updated = state.draftFilter.copyWith(
      minDuration: min,
      maxDuration: max,
      clearDuration: min == null && max == null,
    );
    state = state.copyWith(draftFilter: updated);
  }

  /// Cập nhật Sắp xếp trong Draft
  void updateDraftSortBy(SortOption sortBy) {
    final updated = state.draftFilter.copyWith(sortBy: sortBy);
    state = state.copyWith(draftFilter: updated);
  }

  /// Đặt lại DraftFilter trong Modal Sheet
  void resetDraftFilter({bool keepKeyword = true}) {
    final reset = keepKeyword
        ? state.draftFilter.resetFiltersOnly()
        : state.draftFilter.resetAll();
    state = state.copyWith(draftFilter: reset);
  }

  /// Bấm "Áp dụng bộ lọc": Xác thực và chuyển Draft thành Applied, sau đó kích hoạt tìm kiếm
  Future<void> applyDraftFilter() async {
    // 1. Xác thực giá trị
    var validDraft = state.draftFilter;
    if (validDraft.minPrice > validDraft.maxPrice) {
      validDraft = validDraft.copyWith(
        minPrice: validDraft.maxPrice,
        maxPrice: validDraft.minPrice,
      );
    }

    // Đảm bảo từ khóa trên thanh tìm kiếm được đồng bộ vào filter
    validDraft = validDraft.copyWith(keyword: state.query.trim());

    // 2. Cập nhật AppliedFilter
    state = state.copyWith(
      appliedFilter: validDraft,
      status: SearchStatus.loading,
      clearError: true,
    );

    // 3. Gọi repository thực thi tìm kiếm & cập nhật UI
    try {
      final results = await _repository.search(validDraft);
      state = state.copyWith(
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Lỗi áp dụng bộ lọc. Vui lòng thử lại.',
      );
    }
  }

  /// Quick filter từ Chip Bar: Lọc nhanh danh mục
  Future<void> quickFilterCategory(String? categoryId) async {
    final isSelected = state.appliedFilter.categoryId == categoryId;
    final updated = state.appliedFilter.copyWith(
      categoryId: isSelected ? null : categoryId,
      clearCategory: isSelected,
    );

    state = state.copyWith(
      appliedFilter: updated,
      draftFilter: updated,
      status: SearchStatus.loading,
    );

    try {
      final results = await _repository.search(updated);
      state = state.copyWith(
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(status: SearchStatus.error);
    }
  }

  /// Quick filter từ Chip Bar: Đổi nhanh thứ tự sắp xếp
  Future<void> quickSort(SortOption option) async {
    final updated = state.appliedFilter.copyWith(sortBy: option);
    state = state.copyWith(
      appliedFilter: updated,
      draftFilter: updated,
      status: SearchStatus.loading,
    );

    try {
      final results = await _repository.search(updated);
      state = state.copyWith(
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(status: SearchStatus.error);
    }
  }

  @override
  void dispose() {
    _suggestionDebouncer.dispose();
    super.dispose();
  }
}
