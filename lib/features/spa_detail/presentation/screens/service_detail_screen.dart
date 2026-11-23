import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/data/mock_spa_data.dart';
import '../../../../shared/models/spa.dart';
import '../../../../shared/models/spa_service.dart';
import '../../../../shared/widgets/not_found_view.dart';
import '../../../../shared/widgets/star_rating.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String spaId;
  final String serviceId;

  const ServiceDetailScreen({
    super.key,
    required this.spaId,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final spaList = MockSpaData.getSpas();
    final spaMatches = spaList.where((s) => s.id == spaId);

    if (spaMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy Spa',
            message: 'Thông tin Spa không tồn tại hoặc đã bị xóa.',
          ),
        ),
      );
    }
    final spa = spaMatches.first;

    final serviceMatches = spa.services.where((s) => s.id == serviceId);
    if (serviceMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy dịch vụ',
            message: 'Dịch vụ này không thuộc danh mục Spa đã chọn.',
          ),
        ),
      );
    }
    final service = serviceMatches.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Sliver Image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    service.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black45, Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  // Spa Name Pill
                  GestureDetector(
                    onTap: () => context.push('/spa/${spa.id}'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.storefront_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            spa.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 14, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Service Name
                  Text(service.name, style: AppTextStyles.heading1),
                  const SizedBox(height: 8),

                  // Rating & Duration Row
                  Row(
                    children: [
                      StarRating(rating: service.rating, reviewCount: spa.reviewCount),
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${service.durationMinutes} phút',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Giá niêm yết (toàn hệ thống):',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        Text(
                          CurrencyFormatter.format(service.price),
                          style: AppTextStyles.price.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text('Mô tả liệu trình', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Quy trình các bước
                  const Text('Lợi ích nổi bật', style: AppTextStyles.heading3),
                  const SizedBox(height: 10),
                  _buildBenefitItem('Sử dụng 100% thảo mộc tự nhiên lành tính, không hóa chất'),
                  _buildBenefitItem('Đả thông kinh lạc, kích thích lưu thông máu vùng đầu và vai gáy'),
                  _buildBenefitItem('Giảm căng thẳng mệt mỏi, hỗ trợ giấc ngủ sâu và ngon hơn'),
                  _buildBenefitItem('Được phục vụ bởi kỹ thuật viên tay nghề cao đã qua kiểm duyệt'),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              context.push(
                '/spa/${spa.id}/branch-select?serviceId=${service.id}',
              );
            },
            child: const Text('Chọn chi nhánh & Đặt lịch ngay', style: TextStyle(fontSize: 15)),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13.5, color: AppColors.text, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
