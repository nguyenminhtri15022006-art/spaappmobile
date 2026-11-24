import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/booking_summary_card.dart';
import 'package:spa_marketplace/features/booking/models/booking_model.dart';
import '../view_models/my_bookings_view_model.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  BookingStatus? _currentTab;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(myBookingsViewModelProvider.notifier).loadBookings();
    });
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy lịch hẹn?'),
        content: const Text(
          'Bạn có chắc chắn muốn hủy lịch hẹn này? Thao tác này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Giữ lại lịch'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(myBookingsViewModelProvider.notifier)
                  .cancelBooking(bookingId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã hủy lịch hẹn thành công.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Xác nhận hủy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myBookingsViewModelProvider);
    final bookings = state.bookings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lịch hẹn của tôi'),
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
          // Filter Tabs
          Container(
            height: 48,
            color: AppColors.surface,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: [
                _buildTab(label: 'Tất cả', status: null),
                const SizedBox(width: 8),
                _buildTab(label: 'Đã xác nhận', status: BookingStatus.confirmed),
                const SizedBox(width: 8),
                _buildTab(label: 'Chờ duyệt', status: BookingStatus.pending),
                const SizedBox(width: 8),
                _buildTab(label: 'Đã hoàn thành', status: BookingStatus.completed),
                const SizedBox(width: 8),
                _buildTab(label: 'Đã hủy', status: BookingStatus.cancelled),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Content List
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : bookings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                color: AppColors.secondaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                size: 36,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Chưa có lịch hẹn nào',
                              style: AppTextStyles.heading3,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Khám phá các dịch vụ Spa và đặt lịch ngay hôm nay',
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => context.push('/search'),
                              child: const Text('Tìm kiếm dịch vụ ngay'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final item = bookings[index];
                          return BookingSummaryCard(
                            booking: item,
                            onTap: () {
                              context.push('/my-bookings/${item.id}');
                            },
                            onCancel: item.status == BookingStatus.confirmed
                                ? () => _showCancelDialog(context, item.id)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({required String label, required BookingStatus? status}) {
    final isSelected = _currentTab == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _currentTab = status);
        ref.read(myBookingsViewModelProvider.notifier).loadBookings(status: status);
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.text,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }
}
