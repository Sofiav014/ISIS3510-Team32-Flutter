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
      emit(state.copyWith(date: event.date));
    });
    on<CreateBookingTimeSlotEvent>((event, emit) {
      emit(state.copyWith(timeSlot: event.timeSlot));
    });
    on<CreateBookingMaxUsersEvent>((event, emit) {
      emit(state.copyWith(maxUsers: event.maxUsers));
    });
    on<CreateBookingSubmitEvent>((event, emit) async {
      if (state.date != null &&
          state.timeSlot != null &&
          state.maxUsers != null &&
          state.maxUsers! > 0) {
            
        final updatedUserModel = await bookingRepository.createBooking(
          date: state.date!,
          timeSlot: state.timeSlot!,
          maxUsers: state.maxUsers!,
          venueId: venueId,
          user: authBloc.state.userModel!,
        );

        final sucess = updatedUserModel != null;

        emit(state.copyWith(success: sucess));
      }
    });
  }
}
