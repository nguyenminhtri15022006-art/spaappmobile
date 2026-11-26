import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/luxury_button.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../models/nearby_spa_item.dart';
import '../view_models/nearby_state.dart';
import '../view_models/nearby_view_model.dart';

class NearbyScreen extends ConsumerWidget {
  const NearbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nearbyViewModelProvider);
    final viewModel = ref.read(nearbyViewModelProvider.notifier);
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Spa gần bạn'),
        actions: [
          IconButton(
            tooltip: state.isMapView ? 'Xem danh sách' : 'Xem bản đồ',
            icon: Icon(
              state.isMapView
                  ? Icons.format_list_bulleted_rounded
                  : Icons.map_outlined,
              color: AppColors.primary,
            ),
            onPressed: () => viewModel.toggleViewMode(),
          ),
        ],
      ),
      body: Column(
        children: [
          // User Location Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.surface,
            child: Row(
              children: [
                const Icon(Icons.my_location_rounded, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vị trí của bạn',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        state.userAddress,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => viewModel.refreshLocation(),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Làm mới', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),

          // Radius Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                const Text(
                  'Bán kính:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [1.0, 3.0, 5.0, 10.0].map((radius) {
                        final isSelected = state.selectedRadiusKm == radius;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('${radius.toInt()} km'),
                            selected: isSelected,
                            onSelected: (_) => viewModel.setRadius(radius),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.text,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            backgroundColor: AppColors.chipBackground,
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.border,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _buildBody(context, ref, state, viewModel, currencyFormatter),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    NearbyState state,
    NearbyViewModel viewModel,
    NumberFormat currencyFormatter,
  ) {
    if (state.locationStatus == NearbyLocationStatus.denied) {
      return _buildPermissionState(
        icon: Icons.location_off_rounded,
        title: 'Chưa cấp quyền vị trí',
        message: 'Vui lòng cấp quyền truy cập vị trí để tìm các cơ sở Spa chăm sóc sức khỏe gần bạn nhất.',
        buttonText: 'Cấp quyền truy cập vị trí',
        onPressed: () => viewModel.grantPermission(),
      );
    }

    if (state.locationStatus == NearbyLocationStatus.gpsDisabled) {
      return _buildPermissionState(
        icon: Icons.gps_off_rounded,
        title: 'GPS đang tắt',
        message: 'Dịch vụ định vị trên thiết bị của bạn đang tắt. Bật định vị để hiển thị các Spa quanh bạn.',
        buttonText: 'Bật định vị GPS',
        onPressed: () => viewModel.grantPermission(),
      );
    }

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.fetchNearbySpas(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.spas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.spa_outlined, size: 60, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text(
                'Không tìm thấy Spa nào trong ${state.selectedRadiusKm.toInt()} km',
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Hãy thử tăng bán kính tìm kiếm lên 10 km để khám phá thêm nhiều điểm chăm sóc.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => viewModel.setRadius(10.0),
                child: const Text('Mở rộng bán kính 10 km'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isMapView) {
      return _buildMapView(context, state, viewModel, currencyFormatter);
    }

    return _buildListView(context, state, currencyFormatter);
  }

  Widget _buildPermissionState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.heading2, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    NearbyState state,
    NumberFormat currencyFormatter,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.spas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = state.spas[index];
        return _buildNearbySpaCard(context, item, currencyFormatter);
      },
    );
  }

  Widget _buildNearbySpaCard(
    BuildContext context,
    NearbySpaItem item,
    NumberFormat currencyFormatter,
  ) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      color: AppColors.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/spa/${item.spa.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo / Cover thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.spa.coverUrl,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 84,
                        height: 84,
                        color: AppColors.secondaryLight,
                        child: const Icon(Icons.spa, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.spa.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Distance Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.directions_walk_rounded, size: 13, color: AppColors.accent),
                                  const SizedBox(width: 2),
                                  Text(
                                    item.formattedDistance,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.branch.name,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            StarRating(rating: item.spa.rating, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              '${item.spa.rating} (${item.spa.reviewCount})',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.branch.address,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, color: AppColors.divider),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Giá từ', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text(
                        currencyFormatter.format(item.startingPrice),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _showDirectionsDialog(context, item),
                        icon: const Icon(Icons.navigation_rounded, size: 15),
                        label: const Text('Chỉ đường', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 8),
                      LuxuryButton(
                        text: 'Chi tiết',
                        height: 34,
                        onPressed: () => context.push('/spa/${item.spa.id}'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapView(
    BuildContext context,
    NearbyState state,
    NearbyViewModel viewModel,
    NumberFormat currencyFormatter,
  ) {
    final selectedItem = state.selectedSpa ?? (state.spas.isNotEmpty ? state.spas.first : null);

    return Stack(
      children: [
        // Map Canvas simulation
        Positioned.fill(
          child: Container(
            color: const Color(0xFFF2ECE1),
            child: CustomPaint(
              painter: _MapGridPainter(),
              child: Stack(
                children: [
                  // Center User Location Marker
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.person, color: Colors.white, size: 12),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Bạn đang ở đây',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.text),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pins for nearby spas placed relative to center
                  ...state.spas.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = selectedItem?.branch.id == item.branch.id;

                    // Place pins in a visually pleasing distributed pattern based on index & distance
                    final angle = (index * 1.3) + 0.4;
                    final radiusRatio = (item.distanceKm / (state.selectedRadiusKm + 0.1)).clamp(0.2, 0.85);

                    return Align(
                      alignment: Alignment(
                        (radiusRatio * 0.8) * (index % 2 == 0 ? 1 : -1) * (angle > 2 ? 0.9 : 0.6),
                        (radiusRatio * 0.8) * (index % 3 == 0 ? -1 : 1) * 0.7,
                      ),
                      child: GestureDetector(
                        onTap: () => viewModel.selectSpa(item),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(isSelected ? 6 : 4),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent : AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.spa_rounded,
                                size: isSelected ? 20 : 16,
                                color: isSelected ? Colors.white : AppColors.primary,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Text(
                                item.spa.name.split(' ').first,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        // Bottom Selected Spa Preview Card
        if (selectedItem != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildNearbySpaCard(context, selectedItem, currencyFormatter),
          ),
      ],
    );
  }

  void _showDirectionsDialog(BuildContext context, NearbySpaItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Chỉ đường đến Spa', style: AppTextStyles.heading2),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.secondaryLight,
                  child: Icon(Icons.location_on, color: AppColors.primary),
                ),
                title: Text(item.spa.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(item.branch.address),
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDirectionInfo(Icons.straighten_rounded, 'Khoảng cách', item.formattedDistance),
                  _buildDirectionInfo(
                    Icons.directions_car_rounded,
                    'Thời gian di chuyển',
                    '~ ${(item.distanceKm * 3.5).round().clamp(3, 45)} phút',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đang mở dẫn đường tới ${item.branch.name}...'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.navigation_rounded),
                  label: const Text('Bắt đầu dẫn đường'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFE2D9CC)
      ..strokeWidth = 1.0;

    const double step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Road curve
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width, size.height * 0.4);
    canvas.drawPath(path, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
