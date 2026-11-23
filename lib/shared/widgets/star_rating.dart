import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;
  final TextStyle? textStyle;

  const StarRating({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 14,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAlignment.center,
      children: [
        Icon(
          Icons.star_rounded,
          size: size,
          color: AppColors.starGold,
        ),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 3),
          Text(
            '($reviewCount)',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
