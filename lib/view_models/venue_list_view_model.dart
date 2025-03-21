import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/repositories/venue_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class VenueViewModel extends ChangeNotifier {
  final VenueRepository _venueRepository = VenueRepository();
  List<VenueModel> _venues = [];
  List<VenueModel> get venues => _venues;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  VenueViewModel(String sportName) {
    fetchVenues(sportName);
  }

  Future<void> fetchVenues(String sportName) async {
    _isLoading = true;
    notifyListeners();
    _venues = await _venueRepository.getVenuesBySportId(sportName);
    if (_venues.isNotEmpty) {
      await _sortVenuesByDistance();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _sortVenuesByDistance() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      GeoPoint userLocation = GeoPoint(position.latitude, position.longitude);

      _venues.sort((a, b) {
        double distanceA = _calculateDistance(userLocation, a.coords);
        double distanceB = _calculateDistance(userLocation, b.coords);
        return distanceA.compareTo(distanceB);
      });
    } catch (e) {
      print('Error sorting venues: $e');
    }
  }
  double _calculateDistance(GeoPoint pA, GeoPoint pB){
    double latA = pA.latitude * pi/180;
    double latB = pB.latitude * pi/180;
    double lonA = pA.longitude * pi/180;
    double lonB = pB.longitude * pi/180;

    double earthRadius = 6378*1000;

    return earthRadius*acos(cos(latA)*cos(latB)*cos(lonB-lonA)+sin(latA)*sin(latB));
  }
}