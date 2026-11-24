import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_marketplace/core/constants/app_colors.dart';
import 'package:spa_marketplace/core/constants/app_text_styles.dart';
import 'package:spa_marketplace/shared/data/mock_spa_data.dart';
import 'package:spa_marketplace/shared/models/spa_service.dart';
import 'package:spa_marketplace/shared/widgets/favorite_button.dart';
import 'package:spa_marketplace/shared/widgets/not_found_view.dart';
import 'package:spa_marketplace/shared/widgets/spa_service_card.dart';
import 'package:spa_marketplace/shared/widgets/star_rating.dart';

class SpaDetailScreen extends StatelessWidget {
  final String spaId;
  final String? initialSelectedServiceId;

  const SpaDetailScreen({
    super.key,
    required this.spaId,
    this.initialSelectedServiceId,
  });

  @override
  Widget build(BuildContext context) {
    final spaList = MockSpaData.getSpas();
    final spaMatches = spaList.where((s) => s.id == spaId);

    // Kiểm tra ID Spa hợp lệ
    if (spaMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy Spa',
            message: 'Mã Spa không tồn tại hoặc cơ sở đã ngưng hoạt động.',
          ),
        ),
      );
    }
    final spa = spaMatches.first;

    // Tìm dịch vụ được highlight
    SpaService? highlightedService;
    if (initialSelectedServiceId != null) {
      try {
        highlightedService = spa.services.firstWhere(
          (s) => s.id == initialSelectedServiceId,
        );
      } catch (_) {
        highlightedService = null;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar với ảnh bìa Spa & Nút yêu thích
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FavoriteButton(
                  spaId: spa.id,
                  size: 20,
                  showBackground: true,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                spa.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    spa.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nội dung chi tiết
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Spa: Đánh giá + Số chi nhánh
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StarRating(
                        rating: spa.rating,
                        reviewCount: spa.reviewCount,
                        size: 18,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.secondaryDark),
                        ),
                        child: Text(
                          '${spa.branches.length} chi nhánh hoạt động',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Giới thiệu
                  Text(
                    spa.description,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 12),

                  // DỊCH VỤ ĐƯỢC CHỌN TỪ TÌM KIẾM (HIGHLIGHTED)
                  if (highlightedService != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.accent, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome, color: AppColors.accent, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'DỊCH VỤ BẠN VỪA TÌM KIẾM',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SpaServiceCard(
                            spa: spa,
                            service: highlightedService,
                            isHighlighted: true,
                            onViewDetail: () {
                              context.push('/spa/${spa.id}/service/${highlightedService!.id}');
                            },
                            onBook: () {
                              context.push('/spa/${spa.id}/branch-select?serviceId=${highlightedService!.id}');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Danh sách các dịch vụ khác của Spa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tất cả dịch vụ', style: AppTextStyles.heading2),
                      Text(
                        '(${spa.services.length} liệu trình)',
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...spa.services.map(
                    (srv) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SpaServiceCard(
                        spa: spa,
                        service: srv,
                        isHighlighted: srv.id == initialSelectedServiceId,
                        onViewDetail: () {
                          context.push('/spa/${spa.id}/service/${srv.id}');
                        },
                        onBook: () {
                          context.push('/spa/${spa.id}/branch-select?serviceId=${srv.id}');
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 12),

                  // Danh sách các chi nhánh của Spa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hệ thống chi nhánh', style: AppTextStyles.heading2),
                      Text(
                        '(${spa.branches.length} địa điểm)',
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...spa.branches.map(
                    (br) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.storefront_rounded, size: 20, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        br.name,
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ),
                                    if (br.isHeadquarters)
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
                                const SizedBox(height: 4),
                                Text(
                                  br.address,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Hotline: ${br.phone}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
