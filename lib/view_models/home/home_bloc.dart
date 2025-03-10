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

      // 2. Fetch User Data
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        emit(const HomeError('User not found.'));
        return;
      }

      UserModel user = await UserModel.fromDocumentSnapshot(userDoc);

      // 3. Fetch Upcoming Bookings (All)
      QuerySnapshot allSnapshot = await _firestore
          .collection('bookings')
          .where('start_time', isGreaterThan: DateTime.now())
          .orderBy('start_time')
          .get();

      List<BookingModel> allBookings = await Future.wait(allSnapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc)));

      // 4. Upcoming Bookings from user
      List<BookingModel> upcomingBookings = allBookings.where((booking) {
        return booking.users.any((userRef) => userRef.id == userId);
      }).toList();

      // 5. Fetch Recommended Bookings by user's liked sports (not already joined)
      List<String> likedSportIds =
          user.sportsLiked.map((sport) => sport.id).toList();

      List<BookingModel> recommendedBookings = allBookings.where((booking) {
        return likedSportIds.contains(booking.venue.sport.id) &&
            !upcomingBookings.map((match) => match.id).contains(booking.id);
      }).toList();

      emit(HomeLoaded(
          upcomingBookings: upcomingBookings,
          recommendedBookings: recommendedBookings));
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
      print('Error: $e');
    }
  }
}
