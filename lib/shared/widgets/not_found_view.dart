import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class NotFoundView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? backPath;

  const NotFoundView({
    super.key,
    this.title = 'Không tìm thấy dữ liệu',
    this.message = 'Thông tin bạn yêu cầu không tồn tại hoặc đã được chuyển đi.',
    this.onRetry,
    this.backPath,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = GoRouter.maybeOf(context)?.canPop() ?? false;

    return Center(
      child: Padding(
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
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (canGoBack) ...[
                  OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Quay lại'),
                  ),
                  const SizedBox(width: 12),
                ],
                ElevatedButton.icon(
                  onPressed: () {
                    if (onRetry != null) {
                      onRetry!();
                    } else if (backPath != null) {
                      context.go(backPath!);
                    } else {
                      context.go('/');
                    }
                  },
                  icon: const Icon(Icons.home_rounded, size: 18),
                  label: const Text('Về trang chủ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
