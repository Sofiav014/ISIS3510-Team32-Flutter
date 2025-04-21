import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/core/firebase_service.dart';

class HomeRepository {
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

  Future<Map<String, dynamic>> popularityReport(UserModel user) async {
    final metadata =
        await _firestore.collection('metadata').doc('metadata').get();

    final data = metadata.data() ?? {};
    
    Map<String, dynamic> venuesBookings = data['venues_bookings'] ?? {};
  
    var mostBookedVenue =
      venuesBookings.entries.reduce((a, b) => a.value > b.value ? a : b);
    
    final mostBookedVenueDoc =
      _firestore.collection('venues').doc(mostBookedVenue.key).get();
    
    final highestRatedVenueDoc = await _firestore
      .collection('venues')
      .orderBy('rating', descending: true)
      .limit(1)
      .get();

    // to json (Model)
    final mostBookedVenueModel =
      VenueModel.fromJson((await mostBookedVenueDoc).data() ?? {});
    
    final highestRatedVenueModel = VenueModel.fromJson(highestRatedVenueDoc.docs.first.data());
    

    if (user.bookings.isEmpty) {
      return {
        'highestRatedVenue': highestRatedVenueModel,
        'mostBookedVenue': mostBookedVenueModel,
        'mostPlayedSport': null
      };
    }

    var mostPlayedSport = user.bookings.first.venue.sport;
    var mostPlayedSportCount = 0;
    for (var booking in user.bookings) {
      var count = user.bookings
          .where((b) => b.venue.sport.id == booking.venue.sport.id)
          .length;
      if (count > mostPlayedSportCount) {
        mostPlayedSport = booking.venue.sport;
        mostPlayedSportCount = count;
      }
    }

    return {
      'highestRatedVenue': highestRatedVenueModel,
      'mostBookedVenue': mostBookedVenueModel,
      'mostPlayedSport': mostPlayedSport,
      'mostPlayedSportCount': mostPlayedSportCount
    };
  }
}
