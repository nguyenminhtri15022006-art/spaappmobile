import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../models/spa_search_filter.dart';
import '../../../../shared/data/mock_administrative_repository.dart';
import '../../../../shared/data/mock_spa_data.dart';

class FilterChipBar extends StatelessWidget {
  final SpaSearchFilter filter;
  final AdministrativeRepository adminRepo;
  final VoidCallback onOpenAllFilters;
  final VoidCallback onLocationTap;
  final VoidCallback onPriceTap;
  final VoidCallback onCategoryTap;
  final VoidCallback onRatingTap;
  final ValueChanged<SortOption> onSortChanged;

  const FilterChipBar({
    super.key,
    required this.filter,
    required this.adminRepo,
    required this.onOpenAllFilters,
    required this.onLocationTap,
    required this.onPriceTap,
    required this.onCategoryTap,
    required this.onRatingTap,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định nhãn hiển thị cho từng Chip
    final hasLocation = filter.provinceCode != null && filter.provinceCode!.isNotEmpty;
    final locationLabel = hasLocation
        ? adminRepo.formatLocation(filter.provinceCode, filter.wardCode)
        : 'Địa điểm';

    final hasPrice = filter.minPrice > SpaSearchFilter.defaultMinPrice ||
        filter.maxPrice < SpaSearchFilter.defaultMaxPrice;
    final priceLabel = hasPrice
        ? CurrencyFormatter.formatRange(filter.minPrice, filter.maxPrice)
        : 'Khoảng giá';

    final hasCategory = filter.categoryId != null && filter.categoryId!.isNotEmpty;
    String categoryLabel = 'Danh mục';
    if (hasCategory) {
      final cat = MockSpaData.categories.firstWhere(
        (c) => c.id == filter.categoryId,
        orElse: () => MockSpaData.categories.first,
      );
      categoryLabel = cat.name;
    }

    final hasRating = filter.minRating != null && filter.minRating! > 0;
    final ratingLabel = hasRating ? 'Từ ${filter.minRating}★' : 'Đánh giá';

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Nút mở toàn bộ bộ lọc
          _buildFilterPill(
            label: 'Tất cả bộ lọc',
            icon: Icons.tune_rounded,
            isSelected: filter.activeFilterCount > 0,
            badgeCount: filter.activeFilterCount > 0 ? filter.activeFilterCount : null,
            onTap: onOpenAllFilters,
          ),
          const SizedBox(width: 8),

          // Chip Địa điểm
          _buildFilterPill(
            label: locationLabel,
            icon: Icons.location_on_outlined,
            isSelected: hasLocation,
            onTap: onLocationTap,
          ),
          const SizedBox(width: 8),

          // Chip Giá
          _buildFilterPill(
            label: priceLabel,
            icon: Icons.monetization_on_outlined,
            isSelected: hasPrice,
            onTap: onPriceTap,
          ),
          const SizedBox(width: 8),

          // Chip Danh mục
          _buildFilterPill(
            label: categoryLabel,
            icon: Icons.spa_outlined,
            isSelected: hasCategory,
            onTap: onCategoryTap,
          ),
          const SizedBox(width: 8),

          // Chip Đánh giá
          _buildFilterPill(
            label: ratingLabel,
            icon: Icons.star_outline_rounded,
            isSelected: hasRating,
            onTap: onRatingTap,
          ),
          const SizedBox(width: 8),

          // Chip Sắp xếp nhanh (Popup Menu)
          PopupMenuButton<SortOption>(
            onSelected: onSortChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            elevation: 4,
            itemBuilder: (context) => SortOption.values.map((option) {
              final isCurrent = filter.sortBy == option;
              return PopupMenuItem<SortOption>(
                value: option,
                child: Row(
                  children: [
                    Icon(
                      isCurrent ? Icons.radio_button_checked : Icons.radio_button_off,
                      size: 16,
                      color: isCurrent ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                        color: isCurrent ? AppColors.primary : AppColors.text,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            child: _buildFilterPill(
              label: filter.sortBy.label,
              icon: Icons.sort_rounded,
              isSelected: filter.sortBy != SortOption.relevance,
              onTap: null, // PopupMenuButton handles tap
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required IconData icon,
    required bool isSelected,
    int? badgeCount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.text,
              ),
            ),
            if (badgeCount != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
