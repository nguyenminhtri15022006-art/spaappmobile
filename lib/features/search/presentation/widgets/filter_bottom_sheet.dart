import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/spa_search_filter.dart';
import '../view_models/search_view_model.dart';
import '../../../../shared/data/mock_administrative_repository.dart';
import '../../../../shared/data/mock_spa_data.dart';
import 'location_dropdown_selector.dart';
import 'price_range_filter.dart';

class FilterBottomSheet extends StatelessWidget {
  final SpaSearchFilter draftFilter;
  final AdministrativeRepository adminRepo;
  final SearchViewModel viewModel;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.draftFilter,
    required this.adminRepo,
    required this.viewModel,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.90,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header cố định với nút Đóng và Đặt lại
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22),
                      color: AppColors.text,
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Bộ lọc nâng cao',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    TextButton(
                      onPressed: onReset,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.accent,
                      ),
                      child: const Text(
                        'Đặt lại',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nội dung cuộn được
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
              children: [
                // 1. BỘ LỌC ĐỊA ĐIỂM (Tỉnh/Thành -> Xã/Phường 2 cấp)
                _buildSectionCard(
                  title: '1. Địa điểm chi nhánh',
                  subtitle: 'Theo đơn vị hành chính Việt Nam (2 cấp)',
                  child: LocationDropdownSelector(
                    selectedProvinceCode: draftFilter.provinceCode,
                    selectedWardCode: draftFilter.wardCode,
                    repository: adminRepo,
                    onProvinceChanged: (pCode) {
                      viewModel.updateDraftProvince(pCode);
                    },
                    onWardChanged: (wCode) {
                      viewModel.updateDraftWard(wCode);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 2. BỘ LỌC KHOẢNG GIÁ (RangeSlider)
                _buildSectionCard(
                  title: '2. Khoảng giá',
                  child: PriceRangeFilter(
                    minPrice: draftFilter.minPrice,
                    maxPrice: draftFilter.maxPrice,
                    onChanged: (min, max) {
                      viewModel.updateDraftPriceRange(min, max);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 3. BỘ LỌC DANH MỤC DỊCH VỤ
                _buildSectionCard(
                  title: '3. Danh mục dịch vụ',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MockSpaData.categories.map((category) {
                      final isSelected = draftFilter.categoryId == category.id;
                      return ChoiceChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (_) {
                          viewModel.updateDraftCategory(category.id);
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.text,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. BỘ LỌC ĐÁNH GIÁ (Rating)
                _buildSectionCard(
                  title: '4. Đánh giá Spa',
                  child: Row(
                    children: [
                      _buildRatingChip(label: 'Tất cả', rating: null),
                      const SizedBox(width: 8),
                      _buildRatingChip(label: 'Từ 3★', rating: 3.0),
                      const SizedBox(width: 8),
                      _buildRatingChip(label: 'Từ 4★', rating: 4.0),
                      const SizedBox(width: 8),
                      _buildRatingChip(label: 'Từ 4.5★', rating: 4.5),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 5. BỘ LỌC THỜI LƯỢNG
                _buildSectionCard(
                  title: '5. Thời lượng dịch vụ',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildDurationChip(
                        label: 'Tất cả',
                        min: null,
                        max: null,
                      ),
                      _buildDurationChip(
                        label: '< 30 phút',
                        min: null,
                        max: 29,
                      ),
                      _buildDurationChip(
                        label: '30 – 60 phút',
                        min: 30,
                        max: 60,
                      ),
                      _buildDurationChip(
                        label: '60 – 90 phút',
                        min: 60,
                        max: 90,
                      ),
                      _buildDurationChip(
                        label: '> 90 phút',
                        min: 91,
                        max: null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 6. BỘ LỌC KHOẢNG CÁCH (Hỗ trợ chọn Mốc Demo hoặc tạm vô hiệu hóa chờ GPS)
                _buildSectionCard(
                  title: '6. Bộ lọc khoảng cách',
                  subtitle: draftFilter.demoLocation.isAvailable
                      ? 'Khoảng cách được tính từ: ${draftFilter.demoLocation.label}'
                      : 'Tạm vô hiệu hóa nếu chưa có GPS thật (hoặc chọn Mốc Demo bên dưới)',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Điểm tham chiếu khoảng cách:',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<DemoLocation>(
                        value: draftFilter.demoLocation,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: DemoLocation.values.map((loc) {
                          return DropdownMenuItem(
                            value: loc,
                            child: Text(loc.label, style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (loc) {
                          if (loc != null) {
                            viewModel.updateDraftDemoLocation(loc);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      if (!draftFilter.demoLocation.isAvailable) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.secondaryDark),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accent),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Khoảng cách từ vị trí hiện tại tạm vô hiệu hóa cho đến khi có GPS thật. Bạn có thể chọn mốc Demo ở trên để thử nghiệm tính năng lọc theo bán kính.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Bán kính tối đa từ mốc đã chọn:',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [1.0, 3.0, 5.0, 10.0, 20.0].map((km) {
                            final isSelected = draftFilter.maxDistanceKm == km;
                            return ChoiceChip(
                              label: Text('${km.toInt()} km'),
                              selected: isSelected,
                              onSelected: (_) {
                                viewModel.updateDraftDistance(km);
                              },
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.surface,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? Colors.white : AppColors.text,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                              ),
                              showCheckmark: false,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 7. SẮP XẾP KẾT QUẢ
                _buildSectionCard(
                  title: '7. Sắp xếp theo',
                  child: Column(
                    children: SortOption.values.map((option) {
                      final isSelected = draftFilter.sortBy == option;
                      return RadioListTile<SortOption>(
                        value: option,
                        groupValue: draftFilter.sortBy,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.primary,
                        title: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? AppColors.primary : AppColors.text,
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) viewModel.updateDraftSortBy(val);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Nút "Áp dụng bộ lọc" cố định dưới đáy
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      draftFilter.activeFilterCount > 0
                          ? 'Áp dụng (${draftFilter.activeFilterCount} tiêu chí)'
                          : 'Áp dụng bộ lọc',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildRatingChip({required String label, required double? rating}) {
    final isSelected = draftFilter.minRating == rating;
    return Expanded(
      child: ChoiceChip(
        label: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.text,
            ),
          ),
        ),
        selected: isSelected,
        onSelected: (_) => viewModel.updateDraftRating(rating),
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildDurationChip({
    required String label,
    required int? min,
    required int? max,
  }) {
    final isSelected = draftFilter.minDuration == min && draftFilter.maxDuration == max;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => viewModel.updateDraftDuration(min, max),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.text,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }
}
