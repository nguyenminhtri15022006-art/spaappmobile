import '../models/booking_model.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getBookings({BookingStatus? status});
  Future<BookingModel?> getBookingById(String id);
  Future<BookingModel> createBooking(BookingModel booking);
  Future<bool> cancelBooking(String id, {String reason = ''});
}
