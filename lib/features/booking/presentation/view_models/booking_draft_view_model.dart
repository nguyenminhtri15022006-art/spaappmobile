import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/booking_repository.dart';
import '../../data/mock_booking_repository.dart';
import '../../models/booking_draft.dart';
import '../../models/booking_model.dart';
import 'package:spa_marketplace/shared/data/mock_spa_data.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return MockBookingRepository();
});

final bookingDraftProvider =
    StateNotifierProvider<BookingDraftViewModel, BookingDraft>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return BookingDraftViewModel(repo);
});

class BookingDraftViewModel extends StateNotifier<BookingDraft> {
  final BookingRepository _repository;

  BookingDraftViewModel(this._repository) : super(const BookingDraft());

  /// Khởi tạo hoặc khôi phục bản nháp đặt lịch.
  /// - Khi quay lại cùng một Booking chưa hoàn tất: giữ nguyên dữ liệu hợp lệ (ngày, giờ, ghi chú).
  /// - Khi đổi Spa, chi nhánh hoặc dịch vụ: các lựa chọn không còn hợp lệ phải được reset.
  void initDraft({
    required String spaId,
    required String serviceId,
    required String branchId,
    DateTime? initialDate,
    String? initialTime,
  }) {
    final spas = MockSpaData.getSpas();
    final spaMatches = spas.where((s) => s.id == spaId);
    final spa = spaMatches.isNotEmpty ? spaMatches.first : null;
    final isSpaValid = spa != null;
    final isServiceValid = isSpaValid && spa.services.any((s) => s.id == serviceId);
    final isBranchValid = isSpaValid && spa.branches.any((b) => b.id == branchId);

    final validSpaId = isSpaValid ? spaId : null;
    final validServiceId = isServiceValid ? serviceId : null;
    final validBranchId = isBranchValid ? branchId : null;

    // Khi quay lại cùng một phiên booking hợp lệ, bảo tồn toàn bộ dữ liệu đang chọn
    final isSameBooking = state.spaId == validSpaId &&
        state.serviceId == validServiceId &&
        state.branchId == validBranchId &&
        validSpaId != null;

    if (isSameBooking) {
      // Giữ nguyên ngày, giờ và ghi chú đã chọn
      return;
    }

    // Khi đổi sang Spa khác, các ghi chú của Spa cũ cần được xóa
    final isDifferentSpa = state.spaId != validSpaId;
    final preservedNotes = isDifferentSpa ? '' : state.notes;

    state = BookingDraft(
      spaId: validSpaId,
      serviceId: validServiceId,
      branchId: validBranchId,
      selectedDate: initialDate ?? state.selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      selectedTime: initialTime ?? state.selectedTime ?? '14:30',
      notes: preservedNotes,
      customerName: state.customerName,
      customerPhone: state.customerPhone,
    );
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateTime(String time) {
    state = state.copyWith(selectedTime: time);
  }

  void updateCustomerInfo({
    String? name,
    String? phone,
    String? notes,
  }) {
    state = state.copyWith(
      customerName: name,
      customerPhone: phone,
      notes: notes,
    );
  }

  Future<BookingModel> confirmBooking({required String userId}) async {
    if (!state.isValid) {
      throw Exception('Vui lòng chọn đầy đủ thông tin ngày và giờ hẹn');
    }

    final spaList = MockSpaData.getSpas();
    final spa = spaList.firstWhere(
      (s) => s.id == state.spaId,
      orElse: () => throw Exception('Không tìm thấy thông tin Spa'),
    );

    final service = spa.services.firstWhere(
      (s) => s.id == state.serviceId,
      orElse: () => throw Exception('Không tìm thấy dịch vụ đã chọn'),
    );

    final branch = spa.branches.firstWhere(
      (b) => b.id == state.branchId,
      orElse: () => throw Exception('Không tìm thấy chi nhánh đã chọn'),
    );

    final newBooking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      spaId: spa.id,
      spaName: spa.name,
      branchId: branch.id,
      branchName: branch.name,
      branchAddress: branch.address,
      branchPhone: branch.phone,
      serviceId: service.id,
      serviceName: service.name,
      servicePrice: service.price,
      durationMinutes: service.durationMinutes,
      bookingDate: state.selectedDate!,
      bookingTime: state.selectedTime!,
      notes: state.notes,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    );

    final saved = await _repository.createBooking(newBooking);

    // Reset draft sau khi đặt thành công
    clearDraft();

    return saved;
  }

  void clearDraft() {
    state = const BookingDraft();
  }
}
