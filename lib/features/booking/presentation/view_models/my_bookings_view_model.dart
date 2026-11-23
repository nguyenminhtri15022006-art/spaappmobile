import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/booking_repository.dart';
import '../../models/booking_model.dart';
import 'booking_draft_view_model.dart';

class MyBookingsState {
  final List<BookingModel> bookings;
  final BookingStatus? selectedStatus;
  final bool isLoading;
  final String? errorMessage;

  const MyBookingsState({
    this.bookings = const [],
    this.selectedStatus,
    this.isLoading = false,
    this.errorMessage,
  });

  MyBookingsState copyWith({
    List<BookingModel>? bookings,
    BookingStatus? selectedStatus,
    bool clearStatus = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyBookingsState(
      bookings: bookings ?? this.bookings,
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final myBookingsViewModelProvider =
    StateNotifierProvider<MyBookingsViewModel, MyBookingsState>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return MyBookingsViewModel(repo);
});

class MyBookingsViewModel extends StateNotifier<MyBookingsState> {
  final BookingRepository _repository;

  MyBookingsViewModel(this._repository) : super(const MyBookingsState()) {
    loadBookings();
  }

  Future<void> loadBookings({BookingStatus? status}) async {
    state = state.copyWith(
      isLoading: true,
      selectedStatus: status,
      clearStatus: status == null,
      clearError: true,
    );
    try {
      final list = await _repository.getBookings(status: status);
      state = state.copyWith(bookings: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải danh sách lịch hẹn',
      );
    }
  }

  Future<bool> cancelBooking(String bookingId, {String reason = ''}) async {
    final success = await _repository.cancelBooking(bookingId, reason: reason);
    if (success) {
      await loadBookings(status: state.selectedStatus);
    }
    return success;
  }
}
