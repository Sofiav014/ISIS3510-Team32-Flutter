abstract class CreateBookingEvent {}

class CreateBookingDateEvent extends CreateBookingEvent {
  DateTime date;
  CreateBookingDateEvent(this.date);
}

class CreateBookingTimeSlotEvent extends CreateBookingEvent {
  String timeSlot;
  CreateBookingTimeSlotEvent(this.timeSlot);
}

class CreateBookingTimeSlotEventOverwrite extends CreateBookingEvent {
  CreateBookingTimeSlotEventOverwrite();
}

class CreateBookingMaxUsersEvent extends CreateBookingEvent {
  int maxUsers;
  CreateBookingMaxUsersEvent(this.maxUsers);
}

class CreateBookingSubmitEvent extends CreateBookingEvent {}

class CreateBookingSuccessEvent extends CreateBookingEvent {}

class CreateBookingErrorEvent extends CreateBookingEvent {
  String errorMessage;
  CreateBookingErrorEvent(this.errorMessage);
}
