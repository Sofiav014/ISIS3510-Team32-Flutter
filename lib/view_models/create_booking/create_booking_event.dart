abstract class CreateBookingEvent {}

class CreateBookingDateEvent extends CreateBookingEvent {
  DateTime date;
  CreateBookingDateEvent(this.date);
}

class CreateBookingTimeSlotEvent extends CreateBookingEvent {
  String timeSlot;
  CreateBookingTimeSlotEvent(this.timeSlot);
}

class CreateBookingMaxUsersEvent extends CreateBookingEvent {
  int maxUsers;
  CreateBookingMaxUsersEvent(this.maxUsers);
}

class CreateBookingSubmitEvent extends CreateBookingEvent {}
