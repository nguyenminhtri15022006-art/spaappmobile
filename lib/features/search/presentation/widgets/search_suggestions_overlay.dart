import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelectSuggestion;
  final VoidCallback onDismiss;

  const SearchSuggestionsOverlay({
    super.key,
    required this.suggestions,
    required this.onSelectSuggestion,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GỢI Ý TÌM KIẾM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 0.8,
                  ),
                ),
                GestureDetector(
                  onTap: onDismiss,
                  child: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                leading: const Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                title: Text(
                  suggestion,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.north_west_rounded,
                  size: 15,
                  color: AppColors.textMuted,
                ),
                onTap: () => onSelectSuggestion(suggestion),
              );
            },
          ),
        ],
      ),
    );
  }
}
