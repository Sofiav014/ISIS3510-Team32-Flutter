class CreateBookingState {
  DateTime? date;
  String? timeSlot;
  int? maxUsers;
  bool? success;

  CreateBookingState({
    this.date,
    this.timeSlot,
    this.maxUsers,
    this.success,
  });

  CreateBookingState copyWith({
    DateTime? date,
    String? timeSlot,
    int? maxUsers,
    bool? success,
  }) {
    return CreateBookingState(
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      maxUsers: maxUsers ?? this.maxUsers,
      success: success ?? this.success,
    );
  }
}
