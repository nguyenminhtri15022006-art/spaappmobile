import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/view_models/auth_view_model.dart';
import '../../features/booking/presentation/view_models/my_bookings_view_model.dart';
import '../../features/favorites/presentation/view_models/favorites_view_model.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final isAuthenticated = authState.isAuthenticated;
    final favoriteCount = ref.watch(
      favoritesViewModelProvider.select((s) => s.favoriteSpas.length),
    );
    final bookingCount = ref.watch(
      myBookingsViewModelProvider.select((s) => s.bookings.length),
    );

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // User Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.secondary,
                    backgroundImage: isAuthenticated && user != null
                        ? NetworkImage(user.avatarUrl)
                        : null,
                    child: !isAuthenticated
                        ? const Icon(Icons.person_rounded, size: 30, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Text(
                          isAuthenticated && user != null ? user.name : 'Khách vãng lai',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAuthenticated && user != null
                              ? user.email
                              : 'Đăng nhập để đặt lịch & nhận ưu đãi',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.home_rounded,
                    title: 'Trang chủ',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.search_rounded,
                    title: 'Tìm kiếm dịch vụ',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/search');
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.favorite_rounded,
                    title: 'Spa yêu thích',
                    badgeCount: favoriteCount > 0 ? favoriteCount : null,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/favorites');
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.calendar_today_rounded,
                    title: 'Lịch hẹn của tôi',
                    badgeCount: bookingCount > 0 ? bookingCount : null,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/my-bookings');
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.map_rounded,
                    title: 'Bản đồ chi nhánh',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/map');
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.notifications_rounded,
                    title: 'Thông báo',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/notifications');
                    },
                  ),
                  const Divider(color: AppColors.divider, height: 16),
                  if (isAuthenticated)
                    _buildMenuItem(
                      context: context,
                      icon: Icons.account_circle_rounded,
                      title: 'Hồ sơ cá nhân',
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/profile');
                      },
                    ),
                ],
              ),
            ),

            // Footer (Login / Logout)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: isAuthenticated
                  ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(authViewModelProvider.notifier).logout();
                        },
                        icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                        label: const Text(
                          'Đăng xuất',
                          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/login');
                        },
                        icon: const Icon(Icons.login_rounded, size: 18),
                        label: const Text('Đăng nhập / Đăng ký'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      trailing: badgeCount != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
