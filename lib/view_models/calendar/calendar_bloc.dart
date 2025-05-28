import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/calendar_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';

import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final AuthBloc authBloc;
  final CalendarRepository calendarRepository;
  final ConnectivityRepository connectivityRepository;
  final BookingRepository bookingRepository;
  late final StreamSubscription<bool> _connectivitySubscription;

  CalendarBloc({required this.authBloc, required this.connectivityRepository, required this.calendarRepository, required this.bookingRepository}) : super(CalendarInitial()) {
    on<LoadCalendarData>(_onLoadCalendarData);
    on<SelectDate>(_onSelectDate);

    _connectivitySubscription = connectivityRepository.connectivityChanges.listen((isConnected) {
          if (isConnected) add(const LoadCalendarData());
        }
    );
  }

  Future<void> _onLoadCalendarData(
      LoadCalendarData event, Emitter<CalendarState> emit) async {
    emit(CalendarLoading());
    try {

      final AuthState authState = authBloc.state;
      final UserModel? userModel = authState.userModel;
      if (userModel == null) {
        emit(const CalendarError(message: 'User not found'));
        return;
      }

      final isOnline = await connectivityRepository.hasInternet;

      if (isOnline) {
        final userBookings = await bookingRepository.getBookingsByUserId(userModel.id);
        final bookingsToDisplay = _selectCurrentBookings(userBookings, calendarRepository.getLastDate());
        emit(CalendarLoaded(calendarData: bookingsToDisplay, selectedDate: calendarRepository.getLastDate()));
      }
      else {
        final bookingsToDisplay = _selectCurrentBookings(userModel.bookings, calendarRepository.getLastDate());
        emit(CalendarOfflineLoaded(calendarData: bookingsToDisplay, selectedDate: calendarRepository.getLastDate()));
      }


    } catch (e) {
      emit(CalendarError(message: 'Failed to load calendar data: $e'));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<CalendarState> emit) async {
    emit(CalendarLoading());

    final AuthState authState = authBloc.state;
    final UserModel? userModel = authState.userModel;
    if (userModel == null) {
      emit(const CalendarError(message: 'User not found'));
      return;
    }

    final isOnline = await connectivityRepository.hasInternet;
    calendarRepository.setLastDate(event.selectedDate);

    if (isOnline) {

      final userBookings = await bookingRepository.getBookingsByUserId(userModel.id);
      final bookingsToDisplay = _selectCurrentBookings(userBookings, calendarRepository.getLastDate());

      emit(CalendarLoaded(calendarData: bookingsToDisplay, selectedDate: event.selectedDate));

    } else {

      final bookingsToDisplay = _selectCurrentBookings(userModel.bookings, event.selectedDate);

      emit(CalendarOfflineLoaded( calendarData: bookingsToDisplay, selectedDate: event.selectedDate));
    }
  }

  List<BookingModel> _selectCurrentBookings(List<BookingModel> userBookings, DateTime dateToFilter){
    final filterDate = DateTime(dateToFilter.year, dateToFilter.month, dateToFilter.day);
    List<BookingModel> bookingsSameDate = [];

    for (BookingModel booking in  userBookings){
      final bookingDate = DateTime(booking.startTime.year, booking.startTime.month, booking.startTime.day);
      if (bookingDate.isAtSameMomentAs(filterDate)){
        bookingsSameDate.add(booking);
      }
    }
    return bookingsSameDate;
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }

}