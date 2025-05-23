import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:isis3510_team32_flutter/core/firebase_service.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:flutter/services.dart';
import 'package:isis3510_team32_flutter/models/data_structures/lru_cache.dart';

import 'dart:async';
import 'dart:isolate';

class VenueRepository {
  VenueRepository._internal();

  static final VenueRepository _instance = VenueRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory VenueRepository() {
    return _instance;
  }

  final LRUCache<String, VenueModel> _venueCache = LRUCache(maxSize: 20);

  Future<List<VenueModel>> getVenuesBySportId(String sportName) async {
    try {
      final receivePort = ReceivePort();
      final rootIsolateToken = RootIsolateToken.instance;

      if (rootIsolateToken != null) {
        Map<String, dynamic> params = {
          'sportName': sportName,
          'rootIsolateToken': rootIsolateToken,
          'sendPort': receivePort.sendPort,
          'firebaseOptions': Firebase.app().options
        };
        await Isolate.spawn(_venuesBySportIdIsolate, params);

        final List<VenueModel>? sportVenues = await receivePort.first;

        if (sportVenues != null) {
          for (int i = 0; i < sportVenues.length; i++) {
            final sportVenue = sportVenues[i];
            _venueCache.put(sportVenue.id, sportVenue);
          }

          return sportVenues;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('❗️ Error fetching venues: $e');
      return [];
    }
  }

  Future<List<VenueModel>> getCachedVenuesBySportId(String sportName) async {
    try {
      List<VenueModel> sportVenues = <VenueModel>[];

      final keys = _venueCache.getKeys();
      for (int i = 0; i < keys.length; i++) {
        final venueId = keys[i];
        final venue = _venueCache.get(venueId)!;
        if (venue.sport.name == sportName) {
          sportVenues.add(venue);
        }
      }
      return sportVenues;
    } catch (e) {
      debugPrint('❗️ Error fetching venues: $e');
      return [];
    }
  }

  Future<VenueModel?> getVenueById(String venueId, bool refetch) async {
    try {
      if (!_venueCache.containsKey(venueId) || refetch) {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('venues').doc(venueId).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> venueData =
              documentSnapshot.data() as Map<String, dynamic>;
          venueData['id'] = documentSnapshot.id;
          _venueCache.put(venueId, VenueModel.fromJson(venueData));
        } else {
          return null;
        }
      }
      return _venueCache.get(venueId);
    } catch (e) {
      debugPrint('❗️ Error fetching venue by ID: $e');
      return null;
    }
  }

  Future<VenueModel?> getCachedVenueById(String venueId) async {
    try {
      if (!_venueCache.containsKey(venueId)) {
        return null;
      } else {
        return _venueCache.get(venueId);
      }
    } catch (e) {
      debugPrint('❗️ Error fetching venue by ID: $e');
      return null;
    }
  }

  List<BookingModel> getActiveBookingsByVenue(VenueModel venue, String userId) {
    try {
      if (venue.bookings.isEmpty) {
        return [];
      }
      List<BookingModel> activeBookings = <BookingModel>[];

      final DateTime now = DateTime.now();
      for (int i = 0; i < venue.bookings.length; i++) {
        final booking = venue.bookings[i];
        final startTime = booking.startTime;
        final users = booking.users;
        final numberOfPeople = users.length;

        if (startTime.isAfter(now) &&
            numberOfPeople < booking.maxUsers &&
            !users.contains(userId)) {
          activeBookings.add(booking);
        }
      }

      activeBookings.sort((a, b) => a.startTime.compareTo(b.startTime));

      return activeBookings;
    } catch (e) {
      debugPrint('❗️ Error fetching active bookings: $e');
      return [];
    }
  }

  void _venuesBySportIdIsolate(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;

    final rootIsolateToken = params['rootIsolateToken'] as RootIsolateToken;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final sportName = params['sportName'] as String;

    try {
      final firebaseOptions = params['firebaseOptions'] as FirebaseOptions;

      await Firebase.initializeApp(options: firebaseOptions);

      final firestore = FirebaseService.instance.firestore;

      QuerySnapshot querySnapshot = await firestore
          .collection('venues')
          .where('sport.name', isEqualTo: sportName)
          .get();

      List<VenueModel> sportVenues = querySnapshot.docs.map((doc) {
        Map<String, dynamic> venueData = doc.data() as Map<String, dynamic>;
        venueData['id'] = doc.id;
        return VenueModel.fromJson(venueData);
      }).toList();

      // Send the processed list back to the main isolate
      sendPort.send(sportVenues);
    } catch (e) {
      debugPrint('❗️ Error fetching venues in isolate: $e');
      // If an error occurs, you might want to send an empty list or an error indicator back
      sendPort.send([]);
    }
  }
}
