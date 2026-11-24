import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/data/mock_spa_data.dart';
import '../../../../shared/widgets/not_found_view.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../view_models/booking_draft_view_model.dart';
import '../view_models/my_bookings_view_model.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final String spaId;
  final String serviceId;
  final String branchId;

  const BookingConfirmationScreen({
    super.key,
    required this.spaId,
    required this.serviceId,
    required this.branchId,
  });

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen> {
  bool _isSubmitting = false;

  Future<void> _handleConfirm() async {
    final authUser = ref.read(authViewModelProvider).user;
    if (authUser == null) {
      context.push('/login?redirect=${Uri.encodeComponent(GoRouterState.of(context).uri.toString())}');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Lưu vào Mock Repository
      final newBooking = await ref
          .read(bookingDraftProvider.notifier)
          .confirmBooking(userId: authUser.id);

      // Làm mới danh sách MyBookings
      await ref.read(myBookingsViewModelProvider.notifier).loadBookings();

      if (mounted) {
        setState(() => _isSubmitting = false);
        // Chuyển sang màn hình thành công
        context.go('/booking/success?bookingId=${newBooking.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftProvider);
    final user = ref.watch(authViewModelProvider).user;

    final spaList = MockSpaData.getSpas();
    final spaMatches = spaList.where((s) => s.id == widget.spaId);
    if (spaMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy Spa',
            message: 'Mã Spa không tồn tại hoặc dữ liệu đã bị xóa.',
          ),
        ),
      );
    }
    final spa = spaMatches.first;

    final serviceMatches = spa.services.where((s) => s.id == widget.serviceId);
    if (serviceMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy dịch vụ',
            message: 'Dịch vụ này không thuộc danh mục của Spa đã chọn.',
          ),
        ),
      );
    }
    final service = serviceMatches.first;

    final branchMatches = spa.branches.where((b) => b.id == widget.branchId);
    if (branchMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy chi nhánh',
            message: 'Chi nhánh đã chọn không khả dụng.',
          ),
        ),
      );
    }
    final branch = branchMatches.first;

    final bookingDate = draft.selectedDate ?? DateTime.now().add(const Duration(days: 1));
    final dateFormat = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN');
    final formattedDate = dateFormat.format(bookingDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Xác nhận thông tin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'Kiểm tra lại lịch hẹn của bạn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildRow('Spa thực hiện:', spa.name),
                  _buildRow('Chi nhánh:', branch.name),
                  _buildRow('Địa chỉ:', branch.address),
                  _buildRow('Dịch vụ:', service.name),
                  _buildRow('Thời lượng:', '${service.durationMinutes} phút'),
                  _buildRow('Thời gian hẹn:', '${draft.selectedTime ?? "14:30"} - $formattedDate'),
                  if (draft.notes.isNotEmpty)
                    _buildRow('Ghi chú yêu cầu:', draft.notes),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('THÔNG TIN KHÁCH HÀNG', style: AppTextStyles.caption),
                  const SizedBox(height: 10),
                  _buildRow('Họ tên:', user?.name ?? 'Khách hàng'),
                  _buildRow('Số điện thoại:', user?.phone ?? 'Chưa cập nhật'),
                  _buildRow('Email:', user?.email ?? ''),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondaryDark),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng tiền thanh toán tại Spa:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    CurrencyFormatter.format(service.price),
                    style: AppTextStyles.price.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Nút Xác nhận đặt lịch
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleConfirm,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Xác nhận đặt lịch ngay',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
