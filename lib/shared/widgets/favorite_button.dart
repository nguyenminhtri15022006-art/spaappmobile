import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../features/favorites/presentation/view_models/favorites_view_model.dart';

class FavoriteButton extends ConsumerWidget {
  final String spaId;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.spaId,
    this.size = 20,
    this.activeColor = Colors.redAccent,
    this.inactiveColor,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesViewModelProvider.select((s) => s.isFavorite(spaId)),
    );

    final iconWidget = Icon(
      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      size: size,
      color: isFav ? activeColor : (inactiveColor ?? AppColors.textMuted),
    );

    if (showBackground) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: iconWidget,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: size + 16, minHeight: size + 16),
          onPressed: () {
            ref.read(favoritesViewModelProvider.notifier).toggleFavorite(spaId);
          },
          tooltip: isFav ? 'Bỏ yêu thích' : 'Yêu thích',
        ),
      );
    }

    return IconButton(
      icon: iconWidget,
      onPressed: () {
        ref.read(favoritesViewModelProvider.notifier).toggleFavorite(spaId);
      },
      tooltip: isFav ? 'Bỏ yêu thích' : 'Yêu thích',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
