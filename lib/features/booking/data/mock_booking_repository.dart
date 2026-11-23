import 'booking_repository.dart';
import '../models/booking_model.dart';

class MockBookingRepository implements BookingRepository {
  final List<BookingModel> _bookings = [
    BookingModel(
      id: 'bk_demo_101',
      userId: 'user_001',
      spaId: 'spa_lotus',
      spaName: 'Lotus Wellness Spa',
      branchId: 'br_lotus_q1',
      branchName: 'Lotus Bến Nghé (Quận 1)',
      branchAddress: '45 Lê Thánh Tôn, Phường Bến Nghé, Quận 1',
      branchPhone: '0901234567',
      serviceId: 'srv_lotus_gd60',
      serviceName: 'Gội đầu dưỡng sinh 60 phút',
      servicePrice: 150000,
      durationMinutes: 60,
      bookingDate: DateTime.now().add(const Duration(days: 1)),
      bookingTime: '14:30',
      status: BookingStatus.confirmed,
      notes: 'Thư giãn giảm căng thẳng sau giờ làm',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BookingModel(
      id: 'bk_demo_102',
      userId: 'user_001',
      spaId: 'spa_annam',
      spaName: 'An Nam Herbal Spa',
      branchId: 'br_an_dk',
      branchName: 'An Nam Đa Kao (Quận 1)',
      branchAddress: '26 Đinh Tiên Hoàng, Phường Đa Kao, Quận 1',
      branchPhone: '0977889900',
      serviceId: 'srv_an_ms90',
      serviceName: 'Massage body cổ truyền An Nam 90 phút',
      servicePrice: 550000,
      durationMinutes: 90,
      bookingDate: DateTime.now().subtract(const Duration(days: 5)),
      bookingTime: '10:00',
      status: BookingStatus.completed,
      notes: '',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  @override
  Future<List<BookingModel>> getBookings({BookingStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 120));
    if (status == null) {
      return List.unmodifiable(_bookings);
    }
    return _bookings.where((b) => b.status == status).toList();
  }

  @override
  Future<BookingModel?> getBookingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 60));
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<bool> cancelBooking(String id, {String reason = ''}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      final existing = _bookings[index];
      _bookings[index] = existing.copyWith(status: BookingStatus.cancelled);
      return true;
    }
    return false;
  }
}
