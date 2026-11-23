import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/not_found_view.dart';
import '../models/booking_model.dart';
import '../view_models/booking_draft_view_model.dart';
import '../view_models/my_bookings_view_model.dart';

class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.pending:
        return AppColors.accent;
      case BookingStatus.completed:
        return AppColors.primary;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy lịch hẹn?'),
        content: const Text(
          'Bạn có chắc chắn muốn hủy lịch hẹn này? Spa sẽ nhận được thông báo giải phóng lịch.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(myBookingsViewModelProvider.notifier)
                  .cancelBooking(bookingId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã hủy lịch hẹn thành công.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
                context.pop();
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
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(bookingRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết lịch hẹn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<BookingModel?>(
        future: repo.getBookingById(bookingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final booking = snapshot.data;
          if (booking == null) {
            return const NotFoundView(
              title: 'Không tìm thấy lịch hẹn',
              message: 'Lịch hẹn này không tồn tại hoặc đã bị xóa khỏi hệ thống.',
              backPath: '/my-bookings',
            );
          }

          final dateFormat = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN');
          final formattedDate = dateFormat.format(booking.bookingDate);
          final statusColor = _getStatusColor(booking.status);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                // Status Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.event_available_rounded, color: statusColor, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            'Trạng thái: ${booking.status.label}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mã đặt lịch: #${booking.id}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Spa & Chi nhánh
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      const Text('ĐỊA ĐIỂM HẸN', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Text(
                        booking.spaName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Chi nhánh: ${booking.branchName}',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.branchAddress,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 14, color: AppColors.accent),
                          const SizedBox(width: 6),
                          Text(
                            'Hotline hỗ trợ: ${booking.branchPhone}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Dịch vụ & Thời gian
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      const Text('DỊCH VỤ & THỜI GIAN', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Text(
                        booking.serviceName,
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 6),
                      Text('Thời lượng: ${booking.durationMinutes} phút'),
                      const SizedBox(height: 6),
                      Text('Khung giờ hẹn: ${booking.bookingTime}'),
                      const SizedBox(height: 6),
                      Text('Ngày thực hiện: $formattedDate'),
                      if (booking.notes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Ghi chú: ${booking.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
                      ],
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng chi phí: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            CurrencyFormatter.format(booking.servicePrice),
                            style: AppTextStyles.price.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                if (booking.status == BookingStatus.confirmed) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(context, ref),
                      icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                      label: const Text('Hủy lịch hẹn này', style: TextStyle(color: AppColors.error)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Quay lại danh sách'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
