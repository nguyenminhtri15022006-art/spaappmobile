class BookingDraft {
  final String? spaId;
  final String? branchId;
  final String? serviceId;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String customerName;
  final String customerPhone;
  final String notes;

  const BookingDraft({
    this.spaId,
    this.branchId,
    this.serviceId,
    this.selectedDate,
    this.selectedTime,
    this.customerName = '',
    this.customerPhone = '',
    this.notes = '',
  });

  bool get isValid =>
      spaId != null &&
      branchId != null &&
      serviceId != null &&
      selectedDate != null &&
      selectedTime != null &&
      selectedTime!.isNotEmpty;

  BookingDraft copyWith({
    String? spaId,
    String? branchId,
    String? serviceId,
    DateTime? selectedDate,
    String? selectedTime,
    String? customerName,
    String? customerPhone,
    String? notes,
  }) {
    return BookingDraft(
      spaId: spaId ?? this.spaId,
      branchId: branchId ?? this.branchId,
      serviceId: serviceId ?? this.serviceId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
    );
  }
}
