import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getAvailableTimes(String venueId, DateTime date) async {
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

  Future<List<String>> getAvailableTimesOffline(DateTime date) async {
    // Definir slots de 1 hora desde 7:00 a 23:00
    List<Map<String, String>> allTimeSlots = [
      {'start': '07:00', 'end': '08:00'},
      {'start': '08:00', 'end': '09:00'},
      {'start': '09:00', 'end': '10:00'},
      {'start': '10:00', 'end': '11:00'},
      {'start': '11:00', 'end': '12:00'},
      {'start': '12:00', 'end': '13:00'},
      {'start': '13:00', 'end': '14:00'},
      {'start': '14:00', 'end': '15:00'},
      {'start': '15:00', 'end': '16:00'},
      {'start': '16:00', 'end': '17:00'},
      {'start': '17:00', 'end': '18:00'},
      {'start': '18:00', 'end': '19:00'},
      {'start': '19:00', 'end': '20:00'},
      {'start': '20:00', 'end': '21:00'},
      {'start': '21:00', 'end': '22:00'},
      {'start': '22:00', 'end': '23:00'},
    ];

    DateTime now = DateTime.now();

    // Filtrar slots disponibles
    List<String> availableTimeSlots = allTimeSlots
        .where((slot) {
          int startHour = int.parse(slot['start']!.split(':')[0]);
          int endHour = int.parse(slot['end']!.split(':')[0]);

          // Crear DateTime para el inicio y fin del slot
          DateTime slotStartTime =
              DateTime(date.year, date.month, date.day, startHour, 0, 0);
          DateTime slotEndTime =
              DateTime(date.year, date.month, date.day, endHour, 0, 0);

          if (date.year == now.year &&
              date.month == now.month &&
              date.day == now.day &&
              (slotEndTime.isBefore(now) ||
                  (slotStartTime.isBefore(now) && slotEndTime.isAfter(now)))) {
            return false;
          }

          return true;
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

  Future<UserModel?> createBooking({
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
        'venues_bookings.$venueId': FieldValue.increment(1),
      });

      final venueModel = VenueModel.fromJson(venueInfo);

      // Update the user's bookings in the UserModel
      user.bookings.add(BookingModel(
        id: bookingRef.id,
        maxUsers: maxUsers,
        startTime: startTime,
        endTime: endTime,
        venue: venueModel,
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

      return user;
    } catch (e) {
      print('Error creating booking: $e');
      return null; // Handle errors appropriately
    }
  }

  Future<UserModel?> joinBooking({
    required BookingModel booking,
    required UserModel user,
  }) async {
    try {
      final venueRef = _firestore.collection('venues').doc(booking.venue.id);

      final venueDocSnapshot = await venueRef.get();

      if (!venueDocSnapshot.exists) {
        return null;
      }

      booking.users.add(user.id);

      DocumentReference bookingRef =
          _firestore.collection('bookings').doc(booking.id);

      await bookingRef.update({
        'users': FieldValue.arrayUnion([user.id]),
      });

      await _firestore.collection('users').doc(user.id).update({
        'bookings': FieldValue.arrayUnion([booking.toJson()]),
      });

      List<dynamic> venueBookings = venueDocSnapshot.data()?['bookings'] ?? [];

      final bookingIndex = venueBookings.indexWhere(
        (b) => b['id'] == booking.id,
      );

      if (bookingIndex != -1) {
        venueBookings[bookingIndex]['users'] =
            List<String>.from(venueBookings[bookingIndex]['users'] ?? [])
              ..add(user.id);

        await venueRef.update({'bookings': venueBookings});
      }

      for (var userId in booking.users) {
        if (userId != user.id) {
          final userRef = _firestore.collection('users').doc(userId);
          final userDocSnapshot = await userRef.get();

          List<dynamic> userBookings =
              userDocSnapshot.data()?['bookings'] ?? [];

          final userBookingIndex = userBookings.indexWhere(
            (b) => b['id'] == booking.id,
          );

          if (userBookingIndex != -1) {
            userBookings[userBookingIndex]['users'] =
                List<String>.from(userBookings[userBookingIndex]['users'] ?? [])
                  ..add(user.id);
            await userRef.update({'bookings': userBookings});
          }
        }
      }

      user.bookings.add(booking);

      return user; // Return null if successful, or return the updated user model if needed
    } catch (e) {
      print('Error joining booking: $e');
      return null; // Handle errors appropriately
    }
  }
}
