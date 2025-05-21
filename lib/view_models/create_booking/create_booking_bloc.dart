import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/models/data_structures/lru_cache.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';

class CreateBookingBloc extends Bloc<CreateBookingEvent, CreateBookingState> {
  final BookingRepository bookingRepository;
  final String venueId;
  final AuthBloc authBloc;

  // LRUCache to store user choices
  static final LRUCache<String, dynamic> _cache = LRUCache(maxSize: 5);

  CreateBookingBloc(this.bookingRepository, this.venueId, this.authBloc)
      : super(_initializeState()) {
    on<CreateBookingDateEvent>((event, emit) {
      _cache.put('date', event.date); // Save to cache
      _cache.put('timeSlot', null);
      emit(state.copyWith(
          date: event.date, timeSlot: null, overrideTimeSlot: true));
    });
    on<CreateBookingTimeSlotEvent>((event, emit) {
      _cache.put('timeSlot', event.timeSlot); // Save to cache
      emit(state.copyWith(timeSlot: event.timeSlot));
    });
    on<CreateBookingMaxUsersEvent>((event, emit) {
      _cache.put('maxUsers', event.maxUsers); // Save to cache
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

        final success = updatedUserModel != null;

        emit(state.copyWith(success: success));
      }
    });
  }

  // Initialize state with cached values if available
  static CreateBookingState _initializeState() {
    final cachedDate = _cache.get('date') as DateTime?;
    final cachedTimeSlot = _cache.get('timeSlot') as String?;
    final cachedMaxUsers = _cache.get('maxUsers') as int?;

    return CreateBookingState(
      date: cachedDate ??
          (DateTime.now().hour >= 22
              ? DateTime.now().add(const Duration(days: 1))
              : DateTime.now()),
      timeSlot: cachedTimeSlot,
      maxUsers: cachedMaxUsers,
    );
  }
}
