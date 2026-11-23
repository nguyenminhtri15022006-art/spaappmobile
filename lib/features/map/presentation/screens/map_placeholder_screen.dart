import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/data/mock_spa_data.dart';
import '../../../../shared/models/spa_branch.dart';
import '../../../../shared/widgets/branch_card.dart';

class MapPlaceholderScreen extends StatefulWidget {
  const MapPlaceholderScreen({super.key});

  @override
  State<MapPlaceholderScreen> createState() => _MapPlaceholderScreenState();
}

class _MapPlaceholderScreenState extends State<MapPlaceholderScreen> {
  String _selectedCity = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final allSpas = MockSpaData.getSpas();
    final allBranches = <MapEntry<String, SpaBranch>>[];
    for (final spa in allSpas) {
      for (final branch in spa.branches) {
        allBranches.add(MapEntry(spa.id, branch));
      }
    }

    final filteredBranches = allBranches.where((entry) {
      if (_selectedCity == 'TP.HCM') return entry.value.provinceCode == 'VN-SG';
      if (_selectedCity == 'Hà Nội') return entry.value.provinceCode == 'VN-HN';
      if (_selectedCity == 'Đà Nẵng') return entry.value.provinceCode == 'VN-DN';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bản đồ chi nhánh'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Simulated Map Viewport
          Container(
            height: 220,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Bản đồ giả lập Vector Background
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.map_rounded,
                          size: 44,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Bản đồ vị trí tương tác (Demo Frontend)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sẽ hiển thị Google Maps / OpenStreetMap khi kết nối API',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                // Pins demo
                const Positioned(
                  top: 40,
                  left: 60,
                  child: _MockPin(name: 'Lotus Q.1'),
                ),
                const Positioned(
                  bottom: 50,
                  right: 80,
                  child: _MockPin(name: 'An Nam Spa'),
                ),
                const Positioned(
                  top: 70,
                  right: 120,
                  child: _MockPin(name: "L'Amour Clinic"),
                ),
              ],
            ),
          ),

          // Bộ lọc Tỉnh/Thành phố nhanh
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Tất cả', 'TP.HCM', 'Hà Nội', 'Đà Nẵng'].map((city) {
                final isSelected = _selectedCity == city;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(city),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCity = city),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.text,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Header danh sách chi nhánh
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chi nhánh sẵn sàng (${filteredBranches.length})',
                  style: AppTextStyles.heading3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Danh sách chi nhánh
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: filteredBranches.length,
              itemBuilder: (context, index) {
                final entry = filteredBranches[index];
                final spaId = entry.key;
                final branch = entry.value;

                return BranchCard(
                  branch: branch,
                  actionText: 'Xem Spa',
                  onSelect: () => context.push('/spa/$spaId'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MockPin extends StatelessWidget {
  final String name;

  const _MockPin({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const Icon(Icons.location_on, color: AppColors.accent, size: 22),
      ],
    );
  }
}
