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
        initialDate: DateTime(2026, 12, 1),
        initialTime: '10:30',
      );

      expect(draftViewModel.state.isValid, isTrue);
      expect(draftViewModel.state.spaId, equals('spa_lotus'));
      expect(draftViewModel.state.selectedTime, equals('10:30'));
    });

    test('Giữ nguyên ngày, giờ, ghi chú khi quay lại cùng một draft (sau khi sang Login)', () {
      final chosenDate = DateTime(2026, 12, 25);
      draftViewModel.initDraft(
        spaId: 'spa_lotus',
        serviceId: 'srv_lotus_gd60',
        branchId: 'br_lotus_q1',
        initialDate: chosenDate,
        initialTime: '18:00',
      );

      draftViewModel.updateCustomerInfo(notes: 'Yêu cầu KTV chuyên nghiệp, áp lực vừa phải');

      // Giả lập quay lại BookingFormScreen sau khi người dùng đăng nhập thành công
      // Gọi initDraft với initialDate/initialTime mặc định
      draftViewModel.initDraft(
        spaId: 'spa_lotus',
        serviceId: 'srv_lotus_gd60',
        branchId: 'br_lotus_q1',
        initialDate: DateTime.now().add(const Duration(days: 1)),
        initialTime: '14:30',
      );

      // Phải bảo tồn đúng dữ liệu người dùng đã chọn trước đó, KHÔNG bị ghi đè bởi mặc định
      expect(draftViewModel.state.selectedDate, equals(chosenDate));
      expect(draftViewModel.state.selectedTime, equals('18:00'));
      expect(draftViewModel.state.notes, equals('Yêu cầu KTV chuyên nghiệp, áp lực vừa phải'));
    });

    test('Khi đổi Spa hoặc chi nhánh không hợp lệ, lựa chọn không hợp lệ phải được reset', () {
      draftViewModel.initDraft(
        spaId: 'spa_lotus',
        serviceId: 'srv_lotus_gd60',
        branchId: 'br_lotus_q1',
      );

      draftViewModel.updateCustomerInfo(notes: 'Ghi chú cho Lotus');

      // Đổi sang Spa khác với ID chi nhánh không thuộc Spa đó
      draftViewModel.initDraft(
        spaId: 'spa_green',
        serviceId: 'srv_green_gd45',
        branchId: 'br_lotus_q1', // Chi nhánh này của Lotus, không thuộc Green!
      );

      // Chi nhánh không hợp lệ bị reset
      expect(draftViewModel.state.branchId, isNull);
      // Ghi chú của Spa cũ bị xóa
      expect(draftViewModel.state.notes, isEmpty);
      // SpaId và ServiceId hợp lệ của Green được cập nhật
      expect(draftViewModel.state.spaId, equals('spa_green'));
      expect(draftViewModel.state.serviceId, equals('srv_green_gd45'));
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
      await myBookingsViewModel.loadBookings(status: BookingStatus.confirmed);
      for (final b in myBookingsViewModel.state.bookings) {
        expect(b.status, equals(BookingStatus.confirmed));
      }
    });
  });
}
