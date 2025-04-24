class CreateBookingState {
  DateTime? date;
  String? timeSlot;
  int? maxUsers;

  CreateBookingState({
    this.date,
    this.timeSlot,
    this.maxUsers,
  });

  CreateBookingState copyWith({
    DateTime? date,
    String? timeSlot,
    int? maxUsers,
  }) {
    return CreateBookingState(
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      maxUsers: maxUsers ?? this.maxUsers,
    );
  }
}
