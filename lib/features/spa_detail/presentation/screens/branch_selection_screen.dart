import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/data/mock_spa_data.dart';
import '../../../shared/models/spa_branch.dart';
import '../../search/presentation/view_models/search_view_model.dart';

class BranchSelectionScreen extends ConsumerWidget {
  final String spaId;
  final String serviceId;

  const BranchSelectionScreen({
    super.key,
    required this.spaId,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFilter = ref.watch(
      searchViewModelProvider.select((s) => s.appliedFilter),
    );

    final spaList = MockSpaData.getSpas();
    final spa = spaList.firstWhere(
      (s) => s.id == spaId,
      orElse: () => spaList.first,
    );

    final service = spa.services.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => spa.services.first,
    );

    // Sắp xếp ưu tiên các chi nhánh thuộc tỉnh/thành đã lọc (nếu có)
    final sortedBranches = List<SpaBranch>.from(spa.branches);
    if (searchFilter.provinceCode != null && searchFilter.provinceCode!.isNotEmpty) {
      sortedBranches.sort((a, b) {
        final aMatch = a.provinceCode == searchFilter.provinceCode ? 1 : 0;
        final bMatch = b.provinceCode == searchFilter.provinceCode ? 1 : 0;
        return bMatch.compareTo(aMatch);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chọn chi nhánh đặt lịch'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Thông tin dịch vụ đang đặt
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      service.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.spa),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${spa.name} • ${service.durationMinutes} phút',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Các chi nhánh sẵn sàng phục vụ',
              style: AppTextStyles.heading3,
            ),
            if (searchFilter.provinceCode != null && searchFilter.provinceCode!.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text(
                'Chi nhánh gần khu vực bạn tìm kiếm được ưu tiên hiển thị đầu tiên',
                style: TextStyle(fontSize: 12, color: AppColors.accent),
              ),
            ],
            const SizedBox(height: 14),

            ...sortedBranches.map((branch) {
              final isMatchingFilter = searchFilter.provinceCode != null &&
                  branch.provinceCode == searchFilter.provinceCode;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isMatchingFilter ? AppColors.primary : AppColors.border,
                    width: isMatchingFilter ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        Text(
                          'Hotline: ${branch.phone}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/booking?spaId=${spa.id}&serviceId=${service.id}&branchId=${branch.id}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Chọn'),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
