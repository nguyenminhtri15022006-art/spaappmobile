enum BookingStatus {
  pending('Chờ xác nhận'),
  confirmed('Đã xác nhận'),
  completed('Đã hoàn thành'),
  cancelled('Đã hủy');

  final String label;
  const BookingStatus(this.label);
}

class BookingModel {
  final String id;
  final String userId;
  final String spaId;
  final String spaName;
  final String branchId;
  final String branchName;
  final String branchAddress;
  final String branchPhone;
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final int durationMinutes;
  final DateTime bookingDate;
  final String bookingTime;
  final BookingStatus status;
  final String notes;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.spaId,
    required this.spaName,
    required this.branchId,
    required this.branchName,
    required this.branchAddress,
    required this.branchPhone,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.durationMinutes,
    required this.bookingDate,
    required this.bookingTime,
    this.status = BookingStatus.confirmed,
    this.notes = '',
    required this.createdAt,
  });

  BookingModel copyWith({
    String? id,
    String? userId,
    String? spaId,
    String? spaName,
    String? branchId,
    String? branchName,
    String? branchAddress,
    String? branchPhone,
    String? serviceId,
    String? serviceName,
    double? servicePrice,
    int? durationMinutes,
    DateTime? bookingDate,
    String? bookingTime,
    BookingStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spaId: spaId ?? this.spaId,
      spaName: spaName ?? this.spaName,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      branchAddress: branchAddress ?? this.branchAddress,
      branchPhone: branchPhone ?? this.branchPhone,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
