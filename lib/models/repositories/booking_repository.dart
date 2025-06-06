import 'dart:convert';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isis3510_team32_flutter/core/firebase_service.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/hive/booking_model_hive.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_event.dart';

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

      final upcomingBookings = user.bookings
          .where((booking) => booking.startTime.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      final upcomingHiveBookings = upcomingBookings
          .map((booking) => BookingModelHive.fromModel(booking))
          .toList();

      final box = await Hive.openBox('home_${user.id}');

      await box.put('upcoming_bookings', upcomingHiveBookings);

      return user;
    } catch (e) {
      debugPrint('❗️ Error creating booking: $e');
      return null;
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

      final bookingModelUpdated = BookingModel(
        id: booking.id,
        maxUsers: booking.maxUsers,
        startTime: booking.startTime,
        endTime: booking.endTime,
        venue: booking.venue,
        users: List<String>.from(booking.users),
      );
      user.bookings.add(bookingModelUpdated);

      final upcomingBookings = user.bookings
          .where((booking) => booking.startTime.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      final upcomingHiveBookings = upcomingBookings
          .map((booking) => BookingModelHive.fromModel(booking))
          .toList();

      final box = await Hive.openBox('home_${user.id}');

      await box.put('upcoming_bookings', upcomingHiveBookings);

      return user;
    } catch (e) {
      debugPrint('❗️ Error joining booking: $e');
      return null;
    }
  }

  Future<UserModel?> joinBookingFromVenue({
    required BookingModel booking,
    required UserModel user,
    required VenueModel venue,
  }) async {
    try {
      final venueRef = _firestore.collection('venues').doc(venue.id);

      final venueDocSnapshot = await venueRef.get();
      if (!venueDocSnapshot.exists) {
        return null;
      }

      booking.users.add(user.id);

      final venueModel = {
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
        }
      };

      final bookingModel = {
        'id': booking.id,
        'maxUsers': booking.maxUsers,
        'start_time': booking.startTime,
        'end_time': booking.endTime,
        'venue': venueModel,
        'users': booking.users
      };

      DocumentReference bookingRef =
          _firestore.collection('bookings').doc(booking.id);
      await bookingRef.update({
        'users': FieldValue.arrayUnion([user.id]),
      });

      await _firestore.collection('users').doc(user.id).update({
        'bookings': FieldValue.arrayUnion([bookingModel]),
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

      final bookingModelUpdated = BookingModel(
        id: booking.id,
        maxUsers: booking.maxUsers,
        startTime: booking.startTime,
        endTime: booking.endTime,
        venue: VenueModel.fromJson(venueModel),
        users: List<String>.from(booking.users),
      );

      user.bookings.add(bookingModelUpdated);

      final upcomingBookings = user.bookings
          .where((booking) => booking.startTime.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      final upcomingHiveBookings = upcomingBookings
          .map((booking) => BookingModelHive.fromModel(booking))
          .toList();

      final box = await Hive.openBox('home_${user.id}');

      await box.put('upcoming_bookings', upcomingHiveBookings);

      return user;
    } catch (e) {
      debugPrint('❗️ Error joining booking: $e');
      return null;
    }
  }

  Future<UserModel?> joinBookingIsolate({
    required BookingModel booking,
    required UserModel user,
    required AuthBloc authBloc,
  }) async {
    final receivePort = ReceivePort();

    final rootIsolateToken = RootIsolateToken.instance;

    final bookingJson = jsonEncode(booking.toJsonSerializable());

    final userJson = jsonEncode(user.toJsonSerializable());

    if (rootIsolateToken != null) {
      await Isolate.spawn(_joinBookingIsolate, {
        'receivePort': receivePort.sendPort,
        'rootToken': rootIsolateToken,
        'booking': bookingJson,
        'user': userJson,
        'firebaseOptions': Firebase.app().options,
      });
    } else {
      return null;
    }

    final UserModel? updatedUser = await receivePort.first;

    if (updatedUser != null) {
      authBloc.add(
          AuthChangeModelEvent(FirebaseAuth.instance.currentUser, updatedUser));

      final upcomingBookings = user.bookings
          .where((booking) => booking.startTime.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      final upcomingHiveBookings = upcomingBookings
          .map((booking) => BookingModelHive.fromModel(booking))
          .toList();

      final box = await Hive.openBox('home_${user.id}');

      await box.put('upcoming_bookings', upcomingHiveBookings);
    }

    return updatedUser;
  }

  Future<UserModel?> joinBookingFromVenueIsolate({
    required BookingModel booking,
    required UserModel user,
    required VenueModel venue,
    required AuthBloc authBloc,
  }) async {
    final receivePort = ReceivePort();

    final rootIsolateToken = RootIsolateToken.instance;

    final bookingJson = jsonEncode(booking.toJsonSerializable());

    final venueJson = jsonEncode(venue.toJsonSerializable());

    final userJson = jsonEncode(user.toJsonSerializable());

    if (rootIsolateToken != null) {
      await Isolate.spawn(_joinBookingFromVenueIsolate, {
        'receivePort': receivePort.sendPort,
        'rootToken': rootIsolateToken,
        'booking': bookingJson,
        'user': userJson,
        'venue': venueJson,
        'firebaseOptions': Firebase.app().options,
      });
    } else {
      return null;
    }

    final UserModel? updatedUser = await receivePort.first;

    if (updatedUser != null) {
      authBloc.add(
          AuthChangeModelEvent(FirebaseAuth.instance.currentUser, updatedUser));

      final upcomingBookings = updatedUser.bookings
          .where((booking) => booking.startTime.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      final upcomingHiveBookings = upcomingBookings
          .map((booking) => BookingModelHive.fromModel(booking))
          .toList();

      final box = await Hive.openBox('home_${updatedUser.id}');

      await box.put('upcoming_bookings', upcomingHiveBookings);
    }

    return updatedUser;
  }

  void _joinBookingIsolate(Map<String, dynamic> params) async {
    final sendPort = params['receivePort'] as SendPort;

    final rootIsolateToken = params['rootToken'] as RootIsolateToken;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    try {
      final firebaseOptions = params['firebaseOptions'] as FirebaseOptions;

      await Firebase.initializeApp(
        options: firebaseOptions,
      );

      final bookingJson = params['booking'] as String;

      final userJson = params['user'] as String;

      final booking = BookingModel.fromJson(jsonDecode(bookingJson));

      final user = UserModel.fromJson(jsonDecode(userJson));

      final firestore = FirebaseService.instance.firestore;
      final venueRef = firestore.collection('venues').doc(booking.venue.id);
      final venueDocSnapshot = await venueRef.get();

      if (!venueDocSnapshot.exists) {
        sendPort.send(null);
        return;
      }

      booking.users.add(user.id);

      DocumentReference bookingRef =
          firestore.collection('bookings').doc(booking.id);

      await bookingRef.update({
        'users': FieldValue.arrayUnion([user.id]),
      });

      await firestore.collection('users').doc(user.id).update({
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
          final userRef = firestore.collection('users').doc(userId);
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

      final bookingModelUpdated = BookingModel(
        id: booking.id,
        maxUsers: booking.maxUsers,
        startTime: booking.startTime,
        endTime: booking.endTime,
        venue: booking.venue,
        users: List<String>.from(booking.users),
      );
      user.bookings.add(bookingModelUpdated);

      sendPort.send(user);
    } catch (e) {
      debugPrint('❗️ Error joining booking in isolate: $e');
      sendPort.send(null);
    }
  }

  void _joinBookingFromVenueIsolate(Map<String, dynamic> params) async {
    final sendPort = params['receivePort'] as SendPort;

    final rootIsolateToken = params['rootToken'] as RootIsolateToken;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    try {
      final firebaseOptions = params['firebaseOptions'] as FirebaseOptions;

      await Firebase.initializeApp(
        options: firebaseOptions,
      );

      final bookingJson = params['booking'] as String;

      final userJson = params['user'] as String;

      final venueJson = params['venue'] as String;

      final booking = BookingModel.fromJson(jsonDecode(bookingJson));

      final user = UserModel.fromJson(jsonDecode(userJson));

      final venue = VenueModel.fromJson(jsonDecode(venueJson));

      final firestore = FirebaseService.instance.firestore;

      final venueRef = firestore.collection('venues').doc(venue.id);

      final venueDocSnapshot = await venueRef.get();
      if (!venueDocSnapshot.exists) {
        return null;
      }

      booking.users.add(user.id);

      final venueModel = {
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
        }
      };

      final bookingModel = {
        'id': booking.id,
        'maxUsers': booking.maxUsers,
        'start_time': booking.startTime,
        'end_time': booking.endTime,
        'venue': venueModel,
        'users': booking.users
      };

      DocumentReference bookingRef =
          firestore.collection('bookings').doc(booking.id);
      await bookingRef.update({
        'users': FieldValue.arrayUnion([user.id]),
      });

      await firestore.collection('users').doc(user.id).update({
        'bookings': FieldValue.arrayUnion([bookingModel]),
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
          final userRef = firestore.collection('users').doc(userId);
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

      final bookingModelUpdated = BookingModel(
        id: booking.id,
        maxUsers: booking.maxUsers,
        startTime: booking.startTime,
        endTime: booking.endTime,
        venue: VenueModel.fromJson(venueModel),
        users: List<String>.from(booking.users),
      );

      user.bookings.add(bookingModelUpdated);
      sendPort.send(user);
    } catch (e) {
      debugPrint('❗️ Error joining booking from venue in isolate: $e');
      sendPort.send(null);
    }
  }
}
