import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/booking_summary_card.dart';
import '../../models/booking_model.dart';
import '../view_models/my_bookings_view_model.dart';

enum BookingGroupTab {
  upcoming,
  history,
}

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  BookingGroupTab _selectedGroup = BookingGroupTab.upcoming;
  BookingStatus? _selectedSubStatus;

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

  void _showPaymentDialog(BuildContext context, BookingModel booking) {
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
              const Text('Thanh toán giữ chỗ', style: AppTextStyles.heading2),
              const SizedBox(height: 8),
              Text(
                'Lịch hẹn tại ${booking.spaName} - ${booking.serviceName}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Thời gian giữ chỗ còn lại:'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '14:59',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chuyển tiếp đến cổng thanh toán...'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  child: const Text('Tiến hành thanh toán ngay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myBookingsViewModelProvider);
    final allBookings = state.bookings;

    // Filter by Group: Upcoming vs History
    final groupBookings = allBookings.where((b) {
      if (_selectedGroup == BookingGroupTab.upcoming) {
        return b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.pending ||
            b.status == BookingStatus.pendingPayment;
      } else {
        return b.status == BookingStatus.completed ||
            b.status == BookingStatus.cancelled ||
            b.status == BookingStatus.expired ||
            b.status == BookingStatus.refunded;
      }
    }).toList();

    // Filter by Sub-status if selected
    final filteredBookings = _selectedSubStatus == null
        ? groupBookings
        : groupBookings.where((b) => b.status == _selectedSubStatus).toList();

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                'Đặt lịch mới',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                visualDensity: VisualDensity.compact,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Segmented Tab: Sắp tới vs Lịch sử
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildGroupTabItem(
                      tab: BookingGroupTab.upcoming,
                      title: 'Sắp tới',
                      count: allBookings.where((b) =>
                          b.status == BookingStatus.confirmed ||
                          b.status == BookingStatus.pending ||
                          b.status == BookingStatus.pendingPayment).length,
                    ),
                  ),
                  Expanded(
                    child: _buildGroupTabItem(
                      tab: BookingGroupTab.history,
                      title: 'Lịch sử',
                      count: allBookings.where((b) =>
                          b.status == BookingStatus.completed ||
                          b.status == BookingStatus.cancelled ||
                          b.status == BookingStatus.expired ||
                          b.status == BookingStatus.refunded).length,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sub-filter Chips Row
          Container(
            height: 44,
            color: AppColors.surface,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                _buildSubFilterChip('Tất cả', null),
                if (_selectedGroup == BookingGroupTab.upcoming) ...[
                  const SizedBox(width: 8),
                  _buildSubFilterChip('Đã xác nhận', BookingStatus.confirmed),
                  const SizedBox(width: 8),
                  _buildSubFilterChip('Chờ xác nhận', BookingStatus.pending),
                  const SizedBox(width: 8),
                  _buildSubFilterChip('Chờ thanh toán', BookingStatus.pendingPayment),
                ] else ...[
                  const SizedBox(width: 8),
                  _buildSubFilterChip('Đã hoàn thành', BookingStatus.completed),
                  const SizedBox(width: 8),
                  _buildSubFilterChip('Đã hủy', BookingStatus.cancelled),
                  const SizedBox(width: 8),
                  _buildSubFilterChip('Hết hạn', BookingStatus.expired),
                  const SizedBox(width: 8),
                  _buildSubFilterChip('Đã hoàn tiền', BookingStatus.refunded),
                ],
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
                : filteredBookings.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(28),
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
                              Text(
                                _selectedGroup == BookingGroupTab.upcoming
                                    ? 'Không có lịch hẹn sắp tới'
                                    : 'Không có lịch sử lịch hẹn',
                                style: AppTextStyles.heading3,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Khám phá các dịch vụ Spa chăm sóc sức khỏe và đặt lịch ngay',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () => context.push('/search'),
                                icon: const Icon(Icons.search_rounded, size: 18),
                                label: const Text('Tìm kiếm & Đặt lịch mới'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final item = filteredBookings[index];
                          return BookingSummaryCard(
                            booking: item,
                            onTap: () {
                              context.push('/my-bookings/${item.id}');
                            },
                            onCancel: item.status == BookingStatus.confirmed ||
                                    item.status == BookingStatus.pending ||
                                    item.status == BookingStatus.pendingPayment
                                ? () => _showCancelDialog(context, item.id)
                                : null,
                            onPayNow: item.status == BookingStatus.pendingPayment
                                ? () => _showPaymentDialog(context, item)
                                : null,
                            onRebook: item.status == BookingStatus.completed ||
                                    item.status == BookingStatus.cancelled ||
                                    item.status == BookingStatus.expired
                                ? () {
                                    context.push(
                                      '/spa/${item.spaId}?serviceId=${item.serviceId}',
                                    );
                                  }
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTabItem({
    required BookingGroupTab tab,
    required String title,
    required int count,
  }) {
    final isSelected = _selectedGroup == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGroup = tab;
          _selectedSubStatus = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.25) : AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.text,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubFilterChip(String label, BookingStatus? status) {
    final isSelected = _selectedSubStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedSubStatus = status);
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.text,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
