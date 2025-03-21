import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/repositories/venue_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'venue_list_event.dart';
part 'venue_list_state.dart';

class VenueListBloc extends Bloc<VenueListEvent, VenueListState> {
  final String sportName;
  final VenueRepository venueRepository;
  VenueListBloc({required this.sportName, required this.venueRepository})
      : super(VenueListInitial()) {
    on<LoadVenueListData>(_onLoadVenueListData);
  }

  Future<void> _onLoadVenueListData(
      LoadVenueListData event, Emitter<VenueListState> emit) async {
    emit(VenueListLoading());
    try {
      var venueList = await venueRepository.getVenuesBySportId(sportName);

      if (venueList.isEmpty) {
        emit(const VenueListLoaded(venues: []));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(const VenueListError('Location permissions are denied.'));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      GeoPoint userLocation = GeoPoint(position.latitude, position.longitude);

      venueList.sort((a, b) {
        double distanceA = _calculateDistance(userLocation, a.coords);
        double distanceB = _calculateDistance(userLocation, b.coords);
        return distanceA.compareTo(distanceB);
      });
      emit(VenueListLoaded(venues: venueList));
    } catch (e) {
      emit(VenueListError('Failed to load search data: $e'));
    }
  }

  double _calculateDistance(GeoPoint pA, GeoPoint pB) {
    double latA = pA.latitude * pi / 180;
    double latB = pB.latitude * pi / 180;
    double lonA = pA.longitude * pi / 180;
    double lonB = pB.longitude * pi / 180;

    double earthRadius = 6378 * 1000;

    return earthRadius *
        acos(cos(latA) * cos(latB) * cos(lonB - lonA) + sin(latA) * sin(latB));
  }
}
