// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';
import 'package:isis3510_team32_flutter/repositories/booking_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthBloc authBloc;
  final BookingRepository bookingRepository;

  HomeBloc({
    required this.authBloc,
    required this.bookingRepository,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {

      final AuthState authState = authBloc.state;
      final UserModel? user = authState.userModel;

      if (user == null) {
        emit(const HomeError('User not found or not authenticated.'));
        return;
      }

      final upcomingBookings = bookingRepository.getUpcomingBookings(user);

      final recommendedBookings = await bookingRepository.getRecommendedBookings(user);

      emit(HomeLoaded(
          upcomingBookings: upcomingBookings,
          recommendedBookings: recommendedBookings));
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
    }
  }
}
