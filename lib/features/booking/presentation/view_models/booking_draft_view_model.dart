import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/booking_repository.dart';
import '../../data/mock_booking_repository.dart';
import '../../models/booking_draft.dart';
import '../../models/booking_model.dart';
import '../../../shared/data/mock_spa_data.dart';

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

  void initDraft({
    required String spaId,
    required String serviceId,
    required String branchId,
    DateTime? initialDate,
    String? initialTime,
  }) {
    state = state.copyWith(
      spaId: spaId,
      serviceId: serviceId,
      branchId: branchId,
      selectedDate: initialDate ?? state.selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      selectedTime: initialTime ?? state.selectedTime ?? '14:30',
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
