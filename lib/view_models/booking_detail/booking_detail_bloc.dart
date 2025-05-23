import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';

part 'booking_detail_event.dart';
part 'booking_detail_state.dart';

class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  final BookingRepository bookingRepository;
  final ConnectivityRepository connectivityRepository;
  final BookingModel booking;

  BookingDetailBloc({
    required this.bookingRepository,
    required this.connectivityRepository,
    required this.booking,
  }) : super(BookingDetailInitial()) {
    on<LoadBookingDetailData>(_onLoadBookingDetailData);
    on<UpdateBooking>(_onUpdateBooking);
  }

  Future<void> _onLoadBookingDetailData(
      LoadBookingDetailData event, Emitter<BookingDetailState> emit) async {
    emit(BookingDetailLoading());
    try {
      final isOnline = await connectivityRepository.hasInternet;
      if (isOnline) {
        emit(BookingDetailLoaded(
            booking: booking, error: false, fetching: true));

        // Fetch the latest booking details from the repository in the background
        final result =
            await bookingRepository.fetchBookingIsolate(booking: booking);

        final updatedBooking = result['booking'] as BookingModel?;
        final error = result['error'] as bool? ?? false;

        emit(BookingDetailLoaded(
          booking: updatedBooking ?? booking,
          error: error,
          fetching: false,
        ));
      } else {
        emit(BookingDetailOfflineLoaded(booking: booking));
      }
    } catch (e) {
      emit(BookingDetailError(message: 'Failed to fetch venue details: $e'));
    }
  }

  Future<void> _onUpdateBooking(
      UpdateBooking event, Emitter<BookingDetailState> emit) async {
    emit(BookingDetailLoading());
    try {
      emit(BookingDetailLoaded(
          booking: event.booking, error: false, fetching: false));
    } catch (e) {
      emit(BookingDetailError(message: 'Failed to fetch venue details: $e'));
    }
  }
}
