import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/data/mock_administrative_repository.dart';
import '../../../../shared/models/administrative_unit.dart';

class LocationQuickScrollBar extends StatelessWidget {
  final String? selectedProvinceCode;
  final String? selectedWardCode;
  final AdministrativeRepository adminRepo;
  final ValueChanged<String?> onProvinceSelected;
  final ValueChanged<String?> onWardSelected;

  const LocationQuickScrollBar({
    super.key,
    required this.selectedProvinceCode,
    required this.selectedWardCode,
    required this.adminRepo,
    required this.onProvinceSelected,
    required this.onWardSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu chưa chọn Tỉnh/Thành -> Hiển thị danh sách các Tỉnh/Thành cuộn ngang để chọn nhanh
    if (selectedProvinceCode == null || selectedProvinceCode!.isEmpty) {
      return FutureBuilder<List<AdministrativeUnit>>(
        future: adminRepo.getProvinces(),
        builder: (context, snapshot) {
          final provinces = snapshot.data ?? [];
          if (provinces.isEmpty) return const SizedBox.shrink();

          return Container(
            height: 38,
            margin: const EdgeInsets.only(bottom: 6),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildQuickChip(
                  label: 'Toàn quốc',
                  isSelected: true,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                ...provinces.map((p) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildQuickChip(
                      label: p.name,
                      isSelected: false,
                      onTap: () => onProvinceSelected(p.code),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      );
    }

    // Khi ĐÃ CHỌN một Tỉnh/Thành cụ thể -> Thanh cuộn lập tức chứa các Xã/Phường của Tỉnh đó!
    final province = adminRepo.getProvinceByCode(selectedProvinceCode!);
    final provinceName = province?.name ?? 'Tỉnh đã chọn';

    return FutureBuilder<List<AdministrativeUnit>>(
      future: adminRepo.getWards(selectedProvinceCode!),
      builder: (context, snapshot) {
        final wards = snapshot.data ?? [];

        return Container(
          height: 38,
          margin: const EdgeInsets.only(bottom: 6),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Badge tỉnh đang chọn kèm nút (X) để hủy lọc tỉnh
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_city_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      provinceName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 2),
                    GestureDetector(
                      onTap: () => onProvinceSelected(null),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(Icons.close_rounded,
                            size: 15, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),

              // Chip "Tất cả" của tỉnh
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildQuickChip(
                  label: 'Tất cả $provinceName',
                  isSelected: selectedWardCode == null || selectedWardCode!.isEmpty,
                  onTap: () => onWardSelected(null),
                ),
              ),

              // Danh sách các Xã / Phường / Huyện thuộc Tỉnh đó
              ...wards.map((w) {
                final isSelected = selectedWardCode == w.code;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildQuickChip(
                    label: w.name,
                    isSelected: isSelected,
                    onTap: () => onWardSelected(w.code),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}
