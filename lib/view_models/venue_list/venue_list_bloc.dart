import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/venue_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'venue_list_event.dart';
part 'venue_list_state.dart';

class VenueListBloc extends Bloc<VenueListEvent, VenueListState> {
  final String sportName;
  final VenueRepository venueRepository;
  final ConnectivityRepository connectivityRepository;
  late final StreamSubscription<bool> _connectivitySubscription;

    VenueListBloc({required this.sportName, required this.venueRepository, required this.connectivityRepository}): super(VenueListInitial()) {
            on<LoadVenueListData>(_onLoadVenueListData);
            _connectivitySubscription = connectivityRepository.connectivityChanges.listen((isConnected) {
              if (isConnected) add(const LoadVenueListData()); });
          }

  Future<void> _onLoadVenueListData(
      LoadVenueListData event, Emitter<VenueListState> emit) async {
    emit(VenueListLoading());
    try {
      final isOnline = await connectivityRepository.hasInternet;

      if (isOnline) {
        try {
          var venueList = await venueRepository.getVenuesBySportId(sportName);

          if (venueList.isEmpty) {
            emit(const VenueListLoaded(venues: []));
            return;
          }

          bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

          if (!isLocationServiceEnabled) {
            venueList = venueList.map((venue) {
              return venue.copyWith(distance: 'Distance not available');
            }).toList();

            emit(VenueListLoaded(venues: venueList));
            return;
          }

          LocationPermission permission = await Geolocator.checkPermission();

          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }

          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            venueList = venueList.map((venue) {
              return venue.copyWith(distance: 'Distance not available');
            }).toList();
            emit(VenueListLoaded(venues: venueList));
            return;
          }

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low);
          GeoPoint userLocation =
          GeoPoint(position.latitude, position.longitude);

          venueList = venueList.map((venue) {
            double distance = _calculateDistance(userLocation, venue.coords);
            return venue.copyWith(
                distance: '${distance.toStringAsFixed(2)} km away');
          }).toList();

          venueList.sort((a, b) => a.distance!.compareTo(b.distance!));

          emit(VenueListLoaded(venues: venueList));
        } catch (e) {

          final cachedVenues = await venueRepository.getCachedVenuesBySportId(sportName);
          if (cachedVenues.isNotEmpty) {
            emit(VenueListOfflineLoaded(venues: cachedVenues));
          } else {
            emit(VenueListError('Failed to load venue data: $e'));
          }
        }
      } else {
        final cachedVenues = await venueRepository.getCachedVenuesBySportId(sportName);
          emit(VenueListOfflineLoaded(venues: cachedVenues));
      }
    } catch (e) {
      emit(VenueListError('Unexpected error while loading venue data: $e'));
    }
  }

  double _calculateDistance(GeoPoint pA, GeoPoint pB) {
    double latA = pA.latitude * pi / 180;
    double latB = pB.latitude * pi / 180;
    double lonA = pA.longitude * pi / 180;
    double lonB = pB.longitude * pi / 180;

    double earthRadius = 6378.0;

    return earthRadius *
        acos(cos(latA) * cos(latB) * cos(lonB - lonA) + sin(latA) * sin(latB));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
