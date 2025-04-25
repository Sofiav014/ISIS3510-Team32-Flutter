import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getAvailableTimesID(
      String venueId, DateTime date) async {
    final venueDoc = await _firestore.collection('venues').doc(venueId).get();
    final venue = VenueModel.fromJson(venueDoc.data() ?? {});

    // Extraer reservas del día seleccionado
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

    // Definir slots de 1 hora desde 7:00 a 23:00 (16 slots)
    List<Map<String, String>> allTimeSlots = List.generate(
      16,
      (index) => {
        'start': '${(7 + index).toString().padLeft(2, '0')}:00',
        'end': '${(7 + index + 1).toString().padLeft(2, '0')}:00',
      },
    );

    DateTime now = DateTime.now();

    // Verificar disponibilidad del slot
    bool isSlotFree(DateTime slotStart, DateTime slotEnd,
        List<Map<String, DateTime>> bookedRanges) {
      return bookedRanges.every((range) =>
          slotEnd.isBefore(range['start']!) ||
          slotStart.isAfter(range['end']!));
    }

    List<String> availableTimeSlots = allTimeSlots
        .where((slot) {
          int startHour = int.parse(slot['start']!.split(':')[0]);
          int endHour = int.parse(slot['end']!.split(':')[0]);

          // Slot ajustado (e.g., 09:00:01 → 09:59:59)
          DateTime slotStartTime =
              DateTime(date.year, date.month, date.day, startHour, 0, 1);
          DateTime slotEndTime =
              DateTime(date.year, date.month, date.day, endHour - 1, 59, 59);

          // Excluir slots pasados si es hoy
          if (date.year == now.year &&
              date.month == now.month &&
              date.day == now.day &&
              (slotEndTime.isBefore(now) ||
                  (slotStartTime.isBefore(now) && slotEndTime.isAfter(now)))) {
            return false;
          }

          return isSlotFree(slotStartTime, slotEndTime, bookedTimeRanges);
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

  Future<bool> createBookingID({
    required DateTime date,
    required String timeSlot,
    required int maxUsers,
    required String venueId,
    required UserModel user,
  }) async {
    try {
      print('❤️‍🔥 Creating booking with ID $venueId...');
      final venueDoc = await _firestore.collection('venues').doc(venueId).get();
      print('❤️‍🔥 Venue document retrieved: ${venueDoc.data()}');

      final venue = VenueModel.fromJson((venueDoc).data() ?? {});

      print('❤️‍🔥 Venue model created: ${venue.toJson()}');

      // Get the current user's ID
      final userId = user.id;

      print('❤️‍🔥 User ID: $userId');

      // Split the time slot into start and end times
      final times = getTimes(timeSlot, date);
      DateTime startTime = times[0];
      DateTime endTime = times[1];

      print('❤️‍🔥 Start time: $startTime, End time: $endTime');

      final venueInfo = {
        'coords': venue.coords,
        'id': venueId,
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

      print('❤️‍🔥 Venue info: $venueInfo');

      // Create a new booking document in Firestore
      DocumentReference bookingRef =
          await _firestore.collection('bookings').add({
        'end_time': endTime,
        'max_users': maxUsers,
        'start_time': startTime,
        'users': [userId],
        'venue': venueInfo,
      });

      print('❤️‍🔥 Booking document created with ID: ${bookingRef.id}');

      // Update the venue document with the new booking
      await _firestore.collection('venues').doc(venueId).update({
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

      print('❤️‍🔥 Venue document updated with new booking.');

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

      print('❤️‍🔥 User document updated with new booking.');

      // Update Metadata
      await _firestore.collection('metadata').doc('metadata').update({
        'sports_bookings.${venue.sport.name.toLowerCase()}':
            FieldValue.increment(1),
        'venues_bookings.$venueId': FieldValue.increment(1),
      });

      print('❤️‍🔥 Metadata updated with new booking count.');

      // Update the user's bookings in the UserModel
      user.bookings.add(BookingModel(
        id: bookingRef.id,
        maxUsers: maxUsers,
        startTime: startTime,
        endTime: endTime,
        venue: venue,
        users: [userId],
      ));

      print('❤️‍🔥 User bookings updated with new booking.');

      // Update the venue's bookings in the VenueModel
      venue.bookings.add(BookingModel(
        id: bookingRef.id,
        maxUsers: maxUsers,
        startTime: startTime,
        endTime: endTime,
        venue: venue,
        users: [userId],
      ));

      print('❤️‍🔥 Venue bookings updated with new booking.');
      print('❤️‍🔥 Booking created successfully!');
      return true;
    } catch (e) {
      print('Error creating booking: $e');
      return false; // Handle errors appropriately
    }
  }
}
