import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../models/spa_search_filter.dart';

class PriceRangeFilter extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final void Function(double min, double max) onChanged;

  const PriceRangeFilter({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const minLimit = SpaSearchFilter.defaultMinPrice;
    const maxLimit = SpaSearchFilter.defaultMaxPrice;
    final divisions = ((maxLimit - minLimit) / SpaSearchFilter.priceStep).round();

    // Đảm bảo giá trị nằm trong giới hạn hợp lệ
    final currentMin = minPrice.clamp(minLimit, maxLimit);
    final currentMax = maxPrice.clamp(currentMin, maxLimit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Khoảng giá dịch vụ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondaryDark),
              ),
              child: Text(
                CurrencyFormatter.formatRange(currentMin, currentMax),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(currentMin, currentMax),
          min: minLimit,
          max: maxLimit,
          divisions: divisions,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.secondary,
          labels: RangeLabels(
            CurrencyFormatter.format(currentMin),
            CurrencyFormatter.format(currentMax),
          ),
          onChanged: (values) {
            onChanged(values.start, values.end);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.format(minLimit),
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              Text(
                CurrencyFormatter.format(maxLimit),
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
