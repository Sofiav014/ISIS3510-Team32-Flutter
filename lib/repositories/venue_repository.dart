import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';

class VenueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<VenueModel>> getVenuesBySportId(String sportName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('venues')
          .where('sport.name', isEqualTo: sportName)
          .get();

      return querySnapshot.docs.map((doc) {
        return VenueModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching venues: $e');
      return []; // Handle errors appropriately
    }
  }

  List<String> getAvailableTimes(VenueModel venue, DateTime date) {
    // Extract booked time ranges for the given date
    List<Map<String, DateTime>> bookedTimeRanges = venue.bookings
        .where((booking) {
          DateTime startTime = booking.startTime.toLocal();
          return startTime.day == date.day &&
              startTime.month == date.month &&
              startTime.year == date.year;
        })
        .map((booking) => {
              'start': booking.startTime.toLocal(),
              'end': booking.endTime.toLocal(),
            })
        .toList();

    // Define all possible time slots (7 AM to 10 PM)
    List<String> allTimes = List.generate(
      16,
      (index) => '${(7 + index).toString().padLeft(2, '0')}:00',
    );

    // Filter out booked times
    List<String> availableTimes = allTimes.where((time) {
      DateTime slotTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(time.split(':')[0]),
      );

      // Check if the slot time falls within any booked range
      return !bookedTimeRanges.any((range) =>
          slotTime.isAfter(range['start']!) &&
          slotTime.isBefore(range['end']!));
    }).toList();

    return availableTimes;
  }

  Future<bool> createBooking(
    VenueModel venue,
    DateTime startTime,
    DateTime endTime,
    UserModel user,
    int maxUsers,
  ) async {
    try {
      // Get the current user's ID
      final userId = user.id;

      final venueInfo = {
        'coords': venue.coords,
        'id': venue.id,
        'image': venue.image,
        'location_name': venue.locationName,
        'name': venue.name,
        'rating': venue.rating,
        'sport': {
          'id': venue.sport.id,
          'logo': venue.sport.logo,
          'name': venue.sport.name,
        },
      };

      // Create a new booking document in Firestore
      DocumentReference bookingRef =
          await _firestore.collection('bookings').add({
        'end_time': endTime,
        'max_users': maxUsers,
        'start_time': startTime,
        'users': [userId],
        'venue': venueInfo,
      });

      // Update the venue document with the new booking
      await _firestore.collection('venues').doc(venue.id).update({
        'bookings': FieldValue.arrayUnion([
          {
            'end_time': endTime,
            'id': bookingRef.id,
            'max_users': maxUsers,
            'start_time': startTime,
            'users': [userId],
          }
        ]),
      });

      // Update the user document with the new booking
      await _firestore.collection('users').doc(userId).update({
        'bookings': FieldValue.arrayUnion([
          {
            'end_time': endTime,
            'id': bookingRef.id,
            'max_users': maxUsers,
            'start_time': startTime,
            'users': [userId],
            'venue': venueInfo,
          }
        ]),
      });

      // Update the user's bookings in the UserModel
      user.bookings.add(BookingModel(
        id: bookingRef.id,
        maxUsers: maxUsers,
        startTime: startTime,
        endTime: endTime,
        venue: venue,
        users: [userId],
      ));

      // Update the venue's bookings in the VenueModel
      venue.bookings.add(BookingModel(
        id: bookingRef.id,
        maxUsers: maxUsers,
        startTime: startTime,
        endTime: endTime,
        venue: venue,
        users: [userId],
      ));

      return true;
    } catch (e) {
      print('Error creating booking: $e');
      return false; // Handle errors appropriately
    }
  }
}
