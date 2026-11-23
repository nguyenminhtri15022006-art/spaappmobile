import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/features/booking/data/mock_booking_repository.dart';
import 'package:spa_marketplace/features/booking/models/booking_model.dart';
import 'package:spa_marketplace/features/booking/presentation/view_models/booking_draft_view_model.dart';
import 'package:spa_marketplace/features/booking/presentation/view_models/my_bookings_view_model.dart';

void main() {
  late MockBookingRepository repo;
  late BookingDraftViewModel draftViewModel;
  late MyBookingsViewModel myBookingsViewModel;

  setUp(() {
    repo = MockBookingRepository();
    draftViewModel = BookingDraftViewModel(repo);
    myBookingsViewModel = MyBookingsViewModel(repo);
  });

  group('Booking & Draft ViewModel Tests', () {
    test('Khởi tạo draft thành công và kiểm tra tính hợp lệ', () {
      draftViewModel.initDraft(
        spaId: 'spa_lotus',
        serviceId: 'srv_lotus_gd60',
        branchId: 'br_lotus_q1',
        initialDate: DateTime.now().add(const Duration(days: 2)),
        initialTime: '10:30',
      );

      expect(draftViewModel.state.isValid, isTrue);
      expect(draftViewModel.state.spaId, equals('spa_lotus'));
      expect(draftViewModel.state.selectedTime, equals('10:30'));
    });

    test('Xác nhận đặt lịch thành công và lưu vào Mock Repository', () async {
      draftViewModel.initDraft(
        spaId: 'spa_lotus',
        serviceId: 'srv_lotus_gd60',
        branchId: 'br_lotus_q1',
        initialDate: DateTime.now().add(const Duration(days: 2)),
        initialTime: '16:00',
      );

      final newBooking = await draftViewModel.confirmBooking(userId: 'user_123');
      expect(newBooking.id, isNotEmpty);
      expect(newBooking.status, equals(BookingStatus.confirmed));

      // Kiểm tra booking đã được lưu vào MockBookingRepository
      final saved = await repo.getBookingById(newBooking.id);
      expect(saved, isNotNull);
      expect(saved?.serviceName, equals('Gội đầu dưỡng sinh 60 phút'));

      // Draft phải được xóa sau khi đặt thành công
      expect(draftViewModel.state.isValid, isFalse);
    });

    test('Hủy lịch hẹn thành công cập nhật trạng thái cancelled', () async {
      await myBookingsViewModel.loadBookings();
      final initialCount = myBookingsViewModel.state.bookings.length;
      expect(initialCount, greaterThan(0));

      final firstBooking = myBookingsViewModel.state.bookings.first;
      final cancelSuccess = await myBookingsViewModel.cancelBooking(firstBooking.id);

      expect(cancelSuccess, isTrue);
      final updated = await repo.getBookingById(firstBooking.id);
      expect(updated?.status, equals(BookingStatus.cancelled));
    });

    test('Lọc danh sách lịch hẹn theo trạng thái', () async {
      // Lọc danh sách đã xác nhận
      await myBookingsViewModel.loadBookings(status: BookingStatus.confirmed);
      for (final b in myBookingsViewModel.state.bookings) {
        expect(b.status, equals(BookingStatus.confirmed));
      }
    });
  });
}
