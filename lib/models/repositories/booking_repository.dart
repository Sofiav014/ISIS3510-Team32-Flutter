import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    List<Map<String, String>> allTimeSlots = List.generate(
      16,
      (index) => {
        'start': '${(7 + index).toString().padLeft(2, '0')}:00',
        'end': '${(7 + index + 1).toString().padLeft(2, '0')}:00',
      },
    );

    // Filter out booked time slots
    List<String> availableTimeSlots = allTimeSlots
        .where((slot) {
          DateTime slotStartTime = DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(slot['start']!.split(':')[0]),
          );
          DateTime slotEndTime = DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(slot['end']!.split(':')[0]),
          );

          // Check if the slot is completely free (does not overlap with any booked range)
          return bookedTimeRanges.every((range) =>
              slotEndTime.isBefore(range['start']!) ||
              slotStartTime.isAfter(range['end']!));
        })
        .map((slot) => '${slot['start']} - ${slot['end']}')
        .toList();

    return availableTimeSlots;
  }

  Future<List<String>> getAvailableTimesID(
      String venueId, DateTime date) async {
    final venueDoc = await _firestore.collection('venues').doc(venueId).get();

    final venue = VenueModel.fromJson((venueDoc).data() ?? {});

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
    List<Map<String, String>> allTimeSlots = List.generate(
      16,
      (index) => {
        'start': '${(7 + index).toString().padLeft(2, '0')}:00',
        'end': '${(7 + index + 1).toString().padLeft(2, '0')}:00',
      },
    );

    // Filter out booked time slots
    List<String> availableTimeSlots = allTimeSlots
        .where((slot) {
          DateTime slotStartTime = DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(slot['start']!.split(':')[0]),
          );
          DateTime slotEndTime = DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(slot['end']!.split(':')[0]),
          );

          // Check if the slot is completely free (does not overlap with any booked range)
          return bookedTimeRanges.every((range) =>
              slotEndTime.isBefore(range['start']!) ||
              slotStartTime.isAfter(range['end']!));
        })
        .map((slot) => '${slot['start']} - ${slot['end']}')
        .toList();

    return availableTimeSlots;
  }

  List<DateTime> getTimes(String timeSlot, DateTime date) {
    // Split the time slot into start and end times
    final timeSlots = timeSlot.split(' - ');
    DateTime startTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeSlots[0].split(':')[0]),
      int.parse(timeSlots[0].split(':')[1]),
    );
    DateTime endTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeSlots[1].split(':')[0]),
      int.parse(timeSlots[1].split(':')[1]),
    );

    return [startTime, endTime];
  }

  Future<bool> createBooking({
    required DateTime date,
    required String timeSlot,
    required int maxUsers,
    required VenueModel venue,
    required UserModel user,
  }) async {
    try {
      // Get the current user's ID
      final userId = user.id;

      // Split the time slot into start and end times
      final times = getTimes(timeSlot, date);
      DateTime startTime = times[0];
      DateTime endTime = times[1];

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

      // Update Metadata
      await _firestore.collection('metadata').doc('metadata').update({
        'sports_bookings.${venue.sport.name.toLowerCase()}':
            FieldValue.increment(1),
        'venues_bookings.${venue.id}': FieldValue.increment(1),
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

  Future<bool> createBookingID({
    required DateTime date,
    required String timeSlot,
    required int maxUsers,
    required String venueId,
    required UserModel user,
  }) async {
    try {
      final venueDoc = await _firestore.collection('venues').doc(venueId).get();

      final venue = VenueModel.fromJson((venueDoc).data() ?? {});

      // Get the current user's ID
      final userId = user.id;

      // Split the time slot into start and end times
      final times = getTimes(timeSlot, date);
      DateTime startTime = times[0];
      DateTime endTime = times[1];

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

      // Update Metadata
      await _firestore.collection('metadata').doc('metadata').update({
        'sports_bookings.${venue.sport.name.toLowerCase()}':
            FieldValue.increment(1),
        'venues_bookings.${venue.id}': FieldValue.increment(1),
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
