import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/spa_search_filter.dart';
import '../view_models/search_state.dart';
import '../view_models/search_view_model.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/quick_filter_sheets.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_suggestions_overlay.dart';
import '../../../../shared/data/mock_administrative_repository.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialCategoryId;

  const SearchScreen({super.key, this.initialCategoryId});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final currentQuery = ref.read(searchViewModelProvider).query;
    _textController = TextEditingController(text: currentQuery);

    if (widget.initialCategoryId != null && widget.initialCategoryId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchViewModelProvider.notifier).quickFilterCategory(widget.initialCategoryId);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Mở toàn bộ bộ lọc nâng cao
  void _openFilterBottomSheet() {
    final viewModel = ref.read(searchViewModelProvider.notifier);
    final adminRepo = ref.read(administrativeRepositoryProvider);
    viewModel.openFilterSheet();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (context, ref, child) {
          final draftFilter = ref.watch(
            searchViewModelProvider.select((s) => s.draftFilter),
          );
          return FilterBottomSheet(
            draftFilter: draftFilter,
            adminRepo: adminRepo,
            viewModel: viewModel,
            onApply: () {
              Navigator.pop(ctx);
              viewModel.applyDraftFilter();
            },
            onReset: () {
              viewModel.resetDraftFilter(keepKeyword: true);
            },
          );
        },
      ),
    );
  }

  /// 1. Quick Filter: Chỉ mở Danh mục dịch vụ
  void _openCategoryQuickFilter(SearchState state, SearchViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CategoryQuickFilterSheet(
        initialCategoryId: state.appliedFilter.categoryId,
        onApply: (catId) => viewModel.applyQuickCategory(catId),
        onReset: () => viewModel.applyQuickCategory(null),
      ),
    );
  }

  /// 2. Quick Filter: Chỉ mở Đánh giá
  void _openRatingQuickFilter(SearchState state, SearchViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RatingQuickFilterSheet(
        initialRating: state.appliedFilter.minRating,
        onApply: (rating) => viewModel.applyQuickRating(rating),
        onReset: () => viewModel.applyQuickRating(null),
      ),
    );
  }

  /// 3. Quick Filter: Chỉ mở Khoảng giá
  void _openPriceQuickFilter(SearchState state, SearchViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PriceQuickFilterSheet(
        initialMin: state.appliedFilter.minPrice,
        initialMax: state.appliedFilter.maxPrice,
        onApply: (min, max) => viewModel.applyQuickPrice(min, max),
        onReset: () => viewModel.applyQuickPrice(
          SpaSearchFilter.defaultMinPrice,
          SpaSearchFilter.defaultMaxPrice,
        ),
      ),
    );
  }

  /// 4. Quick Filter: Chỉ mở Địa điểm chi nhánh (2 dropdowns Tỉnh/Phường)
  void _openLocationQuickFilter(
    SearchState state,
    SearchViewModel viewModel,
    AdministrativeRepository adminRepo,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LocationQuickFilterSheet(
        initialProvinceCode: state.appliedFilter.provinceCode,
        initialWardCode: state.appliedFilter.wardCode,
        adminRepo: adminRepo,
        onApply: (pCode, wCode) => viewModel.applyQuickLocation(pCode, wCode),
        onReset: () => viewModel.applyQuickLocation(null, null),
      ),
    );
  }

  /// 5. Quick Filter: Chỉ mở Sắp xếp
  void _openSortQuickFilter(SearchState state, SearchViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SortQuickFilterSheet(
        initialSort: state.appliedFilter.sortBy,
        onSelected: (sort) => viewModel.applyQuickSort(sort),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    final viewModel = ref.read(searchViewModelProvider.notifier);
    final adminRepo = ref.read(administrativeRepositoryProvider);

    // Lắng nghe thay đổi query từ bên ngoài (ví dụ bấm suggestion hoặc clear)
    // TUYỆT ĐỐI không gán _textController.text trong build() khi người dùng đang trực tiếp gõ (tránh mất ký tự tiếng Việt Telex/VNI)
    ref.listen<String>(
      searchViewModelProvider.select((s) => s.query),
      (prev, next) {
        if (_textController.text != next && !_focusNode.hasFocus) {
          _textController.value = TextEditingValue(
            text: next,
            selection: TextSelection.collapsed(offset: next.length),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. App Bar với Search TextField và nút Lọc nâng cao
                SearchBarWidget(
                  controller: _textController,
                  focusNode: _focusNode,
                  activeFilterCount: searchState.appliedFilter.activeFilterCount,
                  onChanged: (val) => viewModel.onQueryChanged(val),
                  onSubmitted: (val) => viewModel.submitSearch(val),
                  onClear: () {
                    _textController.clear();
                    viewModel.clearQuery();
                  },
                  onFilterTap: _openFilterBottomSheet,
                  onBackTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                ),

                // 2. Thanh Filter Chips ngang (mỗi chip mở bottom sheet riêng)
                FilterChipBar(
                  filter: searchState.appliedFilter,
                  adminRepo: adminRepo,
                  onOpenAllFilters: _openFilterBottomSheet,
                  onCategoryTap: () => _openCategoryQuickFilter(searchState, viewModel),
                  onRatingTap: () => _openRatingQuickFilter(searchState, viewModel),
                  onSortTap: () => _openSortQuickFilter(searchState, viewModel),
                  onLocationTap: () => _openLocationQuickFilter(searchState, viewModel, adminRepo),
                  onPriceTap: () => _openPriceQuickFilter(searchState, viewModel),
                ),

                const Divider(height: 1, color: AppColors.divider),

                // 3. Thanh đếm kết quả và trạng thái lọc
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        searchState.isLoading
                            ? 'Đang tìm kiếm dịch vụ...'
                            : 'Tìm thấy ${searchState.totalResultsCount} dịch vụ phù hợp',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (searchState.appliedFilter.activeFilterCount > 0)
                        GestureDetector(
                          onTap: () {
                            viewModel.resetDraftFilter(keepKeyword: true);
                            viewModel.applyDraftFilter();
                          },
                          child: const Text(
                            'Xóa bộ lọc',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // 4. Khu vực danh sách kết quả (List Results / States)
                Expanded(
                  child: _buildBodyContent(searchState, viewModel),
                ),
              ],
            ),

            // 5. Overlay gợi ý từ khóa khi người dùng đang nhập
            if (searchState.isSuggestionsVisible &&
                searchState.suggestions.isNotEmpty)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: SearchSuggestionsOverlay(
                  suggestions: searchState.suggestions,
                  onSelectSuggestion: (s) {
                    _focusNode.unfocus();
                    _textController.value = TextEditingValue(
                      text: s,
                      selection: TextSelection.collapsed(offset: s.length),
                    );
                    viewModel.selectSuggestion(s);
                  },
                  onDismiss: () => viewModel.hideSuggestions(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(SearchState state, SearchViewModel viewModel) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Đang tải dịch vụ thư giãn...',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (state.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 54, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Đã có lỗi xảy ra',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => viewModel.submitSearch(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty || state.results.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 36,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Không tìm thấy dịch vụ nào',
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Thử tìm từ khóa khác, hoặc nới lỏng các tiêu chí trong bộ lọc',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (state.appliedFilter.activeFilterCount > 0)
                OutlinedButton.icon(
                  onPressed: () {
                    viewModel.resetDraftFilter(keepKeyword: true);
                    viewModel.applyDraftFilter();
                  },
                  icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                  label: const Text('Đặt lại bộ lọc'),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final resultItem = state.results[index];
        return SearchResultCard(
          item: resultItem,
          onTap: () {
            context.push(
              '/spa/${resultItem.spa.id}/service/${resultItem.service.id}',
            );
          },
        );
      },
    );
  }
}
