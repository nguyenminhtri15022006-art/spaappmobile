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
import '../widgets/search_bar_widget.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_suggestions_overlay.dart';

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

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    final viewModel = ref.read(searchViewModelProvider.notifier);
    final adminRepo = ref.read(administrativeRepositoryProvider);

    // Đồng bộ controller nếu query thay đổi bên ngoài (ví dụ bấm suggestion)
    if (_textController.text != searchState.query) {
      _textController.text = searchState.query;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. App Bar với Search TextField và nút Lọc
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

                // 2. Thanh Filter Chips ngang bên dưới SearchBar
                FilterChipBar(
                  filter: searchState.appliedFilter,
                  adminRepo: adminRepo,
                  onOpenAllFilters: _openFilterBottomSheet,
                  onLocationTap: _openFilterBottomSheet,
                  onPriceTap: _openFilterBottomSheet,
                  onCategoryTap: _openFilterBottomSheet,
                  onRatingTap: _openFilterBottomSheet,
                  onSortChanged: (option) => viewModel.quickSort(option),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Không tìm thấy dịch vụ phù hợp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vui lòng thử tìm với từ khóa khác (ví dụ: gội đầu, massage, nail) hoặc điều chỉnh mở rộng bộ lọc.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  viewModel.resetDraftFilter(keepKeyword: false);
                  viewModel.clearQuery();
                },
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text('Đặt lại tìm kiếm & bộ lọc'),
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
        final item = state.results[index];
        return SearchResultCard(
          item: item,
          onTap: () {
            // Điều hướng sang SpaDetailScreen với spaId và serviceId đã chọn
            context.push(
              '/spa/${item.spa.id}?serviceId=${item.service.id}',
            );
          },
        );
      },
    );
  }
}
