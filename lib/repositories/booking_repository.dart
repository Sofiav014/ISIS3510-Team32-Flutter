import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';
import 'package:isis3510_team32_flutter/core/firebase_service.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  Future<List<BookingModel>> getRecommendedBookings(UserModel user) async {

    final userBookingsId = user.bookings.map((booking) => booking.id).toList();

    final recommendedBookingsQuery = await _firestore
        .collection('bookings')
        .where('venue.sport.id',
            whereIn: user.sportsLiked.map((sport) => sport.id).toList())
        .limit(10)
        .get();

    return recommendedBookingsQuery.docs
        .map((doc) => BookingModel.fromJson(doc.data()))
        .where((booking) => !userBookingsId.contains(booking.id))
        .where((booking) => booking.users.length < booking.maxUsers)
        .take(3)
        .toList();
  }

  List<BookingModel> getUpcomingBookings(UserModel user) {
    return user.bookings
        .where((booking) => booking.startTime.isAfter(DateTime.now()))
        .toList();
  }
}