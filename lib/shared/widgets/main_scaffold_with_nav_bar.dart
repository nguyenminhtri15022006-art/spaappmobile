import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class MainScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        key: const Key('main_bottom_nav_bar'),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: AppColors.border, width: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  currentIndex: currentIndex,
                  activeIcon: Icons.home_rounded,
                  inactiveIcon: Icons.home_outlined,
                  label: 'Trang chủ',
                ),
                _buildNavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  activeIcon: Icons.near_me_rounded,
                  inactiveIcon: Icons.near_me_outlined,
                  label: 'Gần đây',
                ),
                _buildNavItem(
                  index: 2,
                  currentIndex: currentIndex,
                  activeIcon: Icons.calendar_month_rounded,
                  inactiveIcon: Icons.calendar_month_outlined,
                  label: 'Lịch hẹn',
                  isFeatured: true,
                ),
                _buildNavItem(
                  index: 3,
                  currentIndex: currentIndex,
                  activeIcon: Icons.smart_toy_rounded,
                  inactiveIcon: Icons.smart_toy_outlined,
                  label: 'AI tư vấn',
                ),
                _buildNavItem(
                  index: 4,
                  currentIndex: currentIndex,
                  activeIcon: Icons.person_rounded,
                  inactiveIcon: Icons.person_outline_rounded,
                  label: 'Cá nhân',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    bool isFeatured = false,
  }) {
    final isSelected = index == currentIndex;

    final Color activeColor = isFeatured ? AppColors.accent : AppColors.primary;
    const Color inactiveColor = AppColors.textMuted;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          splashColor: activeColor.withOpacity(0.12),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: isFeatured && isSelected
                    ? const EdgeInsets.symmetric(horizontal: 10, vertical: 3)
                    : const EdgeInsets.all(2),
                decoration: isFeatured && isSelected
                    ? BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  size: isFeatured ? 25 : 23,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
