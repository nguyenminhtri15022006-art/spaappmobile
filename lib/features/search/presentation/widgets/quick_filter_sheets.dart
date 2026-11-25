import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/data/mock_administrative_repository.dart';
import '../../../../shared/data/mock_spa_data.dart';
import '../../models/spa_search_filter.dart';
import 'location_dropdown_selector.dart';
import 'price_range_filter.dart';

/// Sheet chỉ chọn Danh mục dịch vụ
class CategoryQuickFilterSheet extends StatefulWidget {
  final String? initialCategoryId;
  final ValueChanged<String?> onApply;
  final VoidCallback onReset;

  const CategoryQuickFilterSheet({
    super.key,
    required this.initialCategoryId,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<CategoryQuickFilterSheet> createState() => _CategoryQuickFilterSheetState();
}

class _CategoryQuickFilterSheetState extends State<CategoryQuickFilterSheet> {
  late String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(
            title: 'Danh mục dịch vụ',
            onReset: () {
              setState(() => _selectedCategoryId = null);
              widget.onReset();
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MockSpaData.categories.map((category) {
                final isSelected = _selectedCategoryId == category.id;
                return ChoiceChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategoryId = selected ? category.id : null;
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    fontSize: 13,
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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_selectedCategoryId);
                  Navigator.pop(context);
                },
                child: const Text('Áp dụng danh mục'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required String title, required VoidCallback onReset}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
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
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sheet chỉ chọn Đánh giá
class RatingQuickFilterSheet extends StatefulWidget {
  final double? initialRating;
  final ValueChanged<double?> onApply;
  final VoidCallback onReset;

  const RatingQuickFilterSheet({
    super.key,
    required this.initialRating,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<RatingQuickFilterSheet> createState() => _RatingQuickFilterSheetState();
}

class _RatingQuickFilterSheetState extends State<RatingQuickFilterSheet> {
  late double? _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Đánh giá Spa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedRating = null);
                        widget.onReset();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.accent,
                      ),
                      child: const Text(
                        'Đặt lại',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_selectedRating);
                  Navigator.pop(context);
                },
                child: const Text('Áp dụng mức đánh giá'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip({required String label, required double? rating}) {
    final isSelected = _selectedRating == rating;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRating = rating;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sheet chỉ chọn Khoảng giá
class PriceQuickFilterSheet extends StatefulWidget {
  final double initialMin;
  final double initialMax;
  final void Function(double min, double max) onApply;
  final VoidCallback onReset;

  const PriceQuickFilterSheet({
    super.key,
    required this.initialMin,
    required this.initialMax,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<PriceQuickFilterSheet> createState() => _PriceQuickFilterSheetState();
}

class _PriceQuickFilterSheetState extends State<PriceQuickFilterSheet> {
  late double _min;
  late double _max;

  @override
  void initState() {
    super.initState();
    _min = widget.initialMin;
    _max = widget.initialMax;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Khoảng giá',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _min = SpaSearchFilter.defaultMinPrice;
                          _max = SpaSearchFilter.defaultMaxPrice;
                        });
                        widget.onReset();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.accent,
                      ),
                      child: const Text(
                        'Đặt lại',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: PriceRangeFilter(
              minPrice: _min,
              maxPrice: _max,
              onChanged: (min, max) {
                setState(() {
                  _min = min;
                  _max = max;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_min, _max);
                  Navigator.pop(context);
                },
                child: const Text('Áp dụng khoảng giá'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sheet chỉ chọn Địa điểm chi nhánh
class LocationQuickFilterSheet extends StatefulWidget {
  final String? initialProvinceCode;
  final String? initialWardCode;
  final AdministrativeRepository adminRepo;
  final void Function(String? provinceCode, String? wardCode) onApply;
  final VoidCallback onReset;

  const LocationQuickFilterSheet({
    super.key,
    required this.initialProvinceCode,
    required this.initialWardCode,
    required this.adminRepo,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<LocationQuickFilterSheet> createState() => _LocationQuickFilterSheetState();
}

class _LocationQuickFilterSheetState extends State<LocationQuickFilterSheet> {
  late String? _provinceCode;
  late String? _wardCode;

  @override
  void initState() {
    super.initState();
    _provinceCode = widget.initialProvinceCode;
    _wardCode = widget.initialWardCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Địa điểm chi nhánh',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _provinceCode = null;
                          _wardCode = null;
                        });
                        widget.onReset();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.accent,
                      ),
                      child: const Text(
                        'Đặt lại',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: LocationDropdownSelector(
              selectedProvinceCode: _provinceCode,
              selectedWardCode: _wardCode,
              repository: widget.adminRepo,
              onProvinceChanged: (pCode) {
                setState(() {
                  _provinceCode = pCode;
                  _wardCode = null; // Tự động reset phường khi đổi tỉnh
                });
              },
              onWardChanged: (wCode) {
                setState(() {
                  _wardCode = wCode;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_provinceCode, _wardCode);
                  Navigator.pop(context);
                },
                child: const Text('Áp dụng địa điểm'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sheet chỉ chọn Sắp xếp
class SortQuickFilterSheet extends StatelessWidget {
  final SortOption initialSort;
  final ValueChanged<SortOption> onSelected;

  const SortQuickFilterSheet({
    super.key,
    required this.initialSort,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Sắp xếp theo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ],
            ),
          ),
          ...SortOption.values.map((option) {
            final isCurrent = initialSort == option;
            return ListTile(
              leading: Icon(
                isCurrent ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isCurrent ? AppColors.primary : AppColors.textMuted,
                size: 20,
              ),
              title: Text(
                option.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  color: isCurrent ? AppColors.primary : AppColors.text,
                ),
              ),
              trailing: isCurrent
                  ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 18)
                  : null,
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}
