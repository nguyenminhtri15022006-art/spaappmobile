import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../view_models/booking_draft_view_model.dart';
import '../models/booking_model.dart';

class BookingSuccessScreen extends ConsumerWidget {
  final String? bookingId;

  const BookingSuccessScreen({super.key, this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(bookingRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<BookingModel?>(
          future: bookingId != null ? repo.getBookingById(bookingId!) : Future.value(null),
          builder: (context, snapshot) {
            final booking = snapshot.data;
            final dateFormat = DateFormat('dd/MM/yyyy');

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 56,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Đặt lịch hẹn thành công!',
                      style: AppTextStyles.heading1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Spa đã nhận được thông tin lịch hẹn của bạn và đang chuẩn bị phục vụ chu đáo nhất.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 28),

                    if (booking != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('Mã đặt hẹn:', '#${booking.id.substring(booking.id.length - 6)}'),
                            const Divider(height: 16, color: AppColors.divider),
                            _buildInfoRow('Spa:', booking.spaName),
                            const Divider(height: 16, color: AppColors.divider),
                            _buildInfoRow('Chi nhánh:', booking.branchName),
                            const Divider(height: 16, color: AppColors.divider),
                            _buildInfoRow('Dịch vụ:', booking.serviceName),
                            const Divider(height: 16, color: AppColors.divider),
                            _buildInfoRow(
                              'Thời gian:',
                              '${booking.bookingTime} ngày ${dateFormat.format(booking.bookingDate)}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.go('/my-bookings'),
                        child: const Text('Xem danh sách lịch hẹn của tôi'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => context.go('/'),
                        child: const Text('Về trang chủ'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
        Text(
          value,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.text),
        ),
      ],
    );
  }
}
