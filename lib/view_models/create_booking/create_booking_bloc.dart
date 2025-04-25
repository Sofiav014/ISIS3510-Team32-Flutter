import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';

class CreateBookingBloc extends Bloc<CreateBookingEvent, CreateBookingState> {
  final BookingRepository bookingRepository;
  // final VenueModel venueModel;
  final String venueId;
  final AuthBloc authBloc;

  CreateBookingBloc(this.bookingRepository, this.venueId, this.authBloc)
      : super(CreateBookingState(
          date: DateTime.now().hour >= 22
              ? DateTime.now().add(const Duration(days: 1))
              : DateTime.now(),
        )) {
    on<CreateBookingDateEvent>((event, emit) {
      print("Date selected: ${event.date}");
      emit(state.copyWith(date: event.date));
    });
    on<CreateBookingTimeSlotEvent>((event, emit) {
      print("Time slot selected: ${event.timeSlot}");
      emit(state.copyWith(timeSlot: event.timeSlot));
    });
    on<CreateBookingMaxUsersEvent>((event, emit) {
      print("Max users selected: ${event.maxUsers}");
      emit(state.copyWith(maxUsers: event.maxUsers));
    });
    on<CreateBookingSubmitEvent>((event, emit) async {
      print(
          "Creating booking with date: ${state.date}, timeSlot: ${state.timeSlot}, maxUsers: ${state.maxUsers}");
      print("Venue ID: $venueId");
      if (state.date != null &&
          state.timeSlot != null &&
          state.maxUsers != null &&
          state.maxUsers! > 0) {
        print("Creating booking...");
        await bookingRepository.createBookingID(
          date: state.date!,
          timeSlot: state.timeSlot!,
          maxUsers: state.maxUsers!,
          venueId: venueId,
          user: authBloc.state.userModel!,
        );
      }
      print("Booking created successfully!");
    });
  }
}
