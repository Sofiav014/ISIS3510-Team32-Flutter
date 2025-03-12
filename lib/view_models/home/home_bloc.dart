// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';
import 'package:isis3510_team32_flutter/core/firebase_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

      // 1. Get User ID from event
      final userId = event.userId;

      if (userId.isEmpty) {
        emit(const HomeError('User ID is missing.'));
        return;
      }

      // 2. Get User data
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        emit(const HomeError('User not found.'));
        return;
      }

      final userDocData = userDoc.data();

      UserModel? user;

      if (userDocData == null) {
        emit(const HomeError('User not found.'));
        return;
      }

      user = UserModel.fromJson(userDocData);

      // 3. Get Bookings data
      final upcomingBookings = user.bookings
          .where((booking) => booking.startTime.isAfter(DateTime.now()))
          .toList();

      final userBookingsId =
          upcomingBookings.map((booking) => booking.id).toList();

      final recommendedBookingsQuery = await _firestore
          .collection('bookings')
          .where('venue.sport.id',
              whereIn: user.sportsLiked.map((sport) => sport.id).toList())
          .limit(
              10) // Increase the limit to ensure we have enough results to filter
          .get();

      final recommendedBookings = recommendedBookingsQuery.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .where((booking) => !userBookingsId.contains(booking.id))
          .where((booking) => booking.users.length < booking.maxUsers)
          .take(3) // Limit the final results to 3
          .toList();

      emit(HomeLoaded(
          upcomingBookings: upcomingBookings,
          recommendedBookings: recommendedBookings));
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
    }
  }
}
