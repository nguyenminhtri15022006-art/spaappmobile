import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../models/spa_branch.dart';

class BranchCard extends StatelessWidget {
  final SpaBranch branch;
  final bool isMatchingFilter;
  final VoidCallback? onSelect;
  final String actionText;

  const BranchCard({
    super.key,
    required this.branch,
    this.isMatchingFilter = false,
    this.onSelect,
    this.actionText = 'Chọn',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMatchingFilter ? AppColors.primary : AppColors.border,
          width: isMatchingFilter ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isMatchingFilter ? AppColors.primary.withOpacity(0.12) : AppColors.secondaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.storefront_rounded,
            color: isMatchingFilter ? AppColors.primary : AppColors.primaryDark,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                branch.name,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
            if (isMatchingFilter)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Phù hợp vị trí lọc',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            else if (branch.isHeadquarters)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Trụ sở chính',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Text(
                branch.address,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    branch.phone,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: onSelect != null
            ? ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isMatchingFilter ? AppColors.primary : AppColors.secondaryLight,
                  foregroundColor: isMatchingFilter ? Colors.white : AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(actionText),
              )
            : null,
      ),
    );
  }
}
