import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/repositories/venue_repository.dart';

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
    _isLoading = false;
    notifyListeners();
  }
}