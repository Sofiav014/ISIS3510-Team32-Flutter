import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isis3510_team32_flutter/models/hive/booking_model_hive.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/core/firebase_service.dart';
import 'package:isis3510_team32_flutter/models/hive/sport_model_hive.dart';
import 'package:isis3510_team32_flutter/models/hive/venue_model_hive.dart';

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  // Online request

  Future<List<BookingModel>> getRecommendedBookings(UserModel user) async {
    final userBookingsId = user.bookings.map((booking) => booking.id).toList();

    final recommendedBookingsQuery = await _firestore
        .collection('bookings')
        .where('venue.sport.id',
            whereIn: user.sportsLiked.map((sport) => sport.id).toList())
        .limit(20)
        .get();

    final recommendedBookings = recommendedBookingsQuery.docs
        .map((doc) => BookingModel.fromFirestore(doc, null))
        .where((booking) => !userBookingsId.contains(booking.id))
        .where((booking) => booking.users.length < booking.maxUsers)
        .toList();

    recommendedBookings.sort((a, b) => a.startTime.compareTo(b.startTime));

    return recommendedBookings.take(3).toList();
  }

  List<BookingModel> getUpcomingBookings(UserModel user) {
    return user.bookings
        .where((booking) => booking.startTime.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
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

    final mostBookedVenueModel =
        VenueModel.fromJson((await mostBookedVenueDoc).data() ?? {});

    final highestRatedVenueModel =
        VenueModel.fromJson(highestRatedVenueDoc.docs.first.data());

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

  // Cache request

  Future<void> cacheHomeData({
    required String userId,
    required List<BookingModel> upcoming,
    required Map<String, dynamic> report,
  }) async {
    final box = await Hive.openBox('home_$userId');
    final upcomingHive =
        upcoming.map((b) => BookingModelHive.fromModel(b)).toList();

    final highestRated = VenueModelHive.fromModel(report['highestRatedVenue']);
    final mostBooked = VenueModelHive.fromModel(report['mostBookedVenue']);
    final mostPlayedSport = report['mostPlayedSport'] != null
        ? SportModelHive.fromModel(report['mostPlayedSport'])
        : null;
    final mostPlayedSportCount = report['mostPlayedSport'] != null
        ? report['mostPlayedSportCount']
        : null;

    await box.put('upcoming_bookings', upcomingHive);
    await box.put('highestRatedVenue', highestRated);
    await box.put('mostBookedVenue', mostBooked);
    await box.put('mostPlayedSport', mostPlayedSport);
    await box.put('mostPlayedSportCount', mostPlayedSportCount);
  }

  Future<List<BookingModel>?> getCachedUpcomingBookings(String userId) async {
    final box = await Hive.openBox('home_$userId');
    final cachedUpcomingBookings = box.get('upcoming_bookings') as List?;

    if (cachedUpcomingBookings == null) return null;

    return (cachedUpcomingBookings)
        .map((e) => (e as BookingModelHive).toModel())
        .toList();
  }

  Future<Map<String, dynamic>?> getCachedPopularityReport(String userId) async {
    final box = await Hive.openBox('home_$userId');
    final cachehighestRatedVenue = box.get('highestRatedVenue');
    final cachemostBookedVenue = box.get('mostBookedVenue');
    final cachemostPlayedSport = box.get('mostPlayedSport');
    final cachemostPlayedSportCount = box.get('mostPlayedSportCount');

    final highestRatedVenue = cachehighestRatedVenue != null
        ? (cachehighestRatedVenue as VenueModelHive).toModel()
        : null;

    final mostBookedVenue = cachemostBookedVenue != null
        ? (cachemostBookedVenue as VenueModelHive).toModel()
        : null;
    final mostPlayedSport = cachemostPlayedSport != null
        ? (cachemostPlayedSport as SportModelHive).toModel()
        : null;
    final mostPlayedSportCount = cachemostPlayedSportCount != null
        ? cachemostPlayedSportCount as int
        : null;

    return {
      'highestRatedVenue': highestRatedVenue,
      'mostBookedVenue': mostBookedVenue,
      'mostPlayedSport': mostPlayedSport,
      'mostPlayedSportCount': mostPlayedSportCount,
    };
  }
}
