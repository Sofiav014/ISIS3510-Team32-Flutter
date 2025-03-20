import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/models/sport.dart';
import 'package:isis3510_team32_flutter/repositories/sport_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SportRepository _sportRepository = SportRepository();
  List<Sport> _sports = [];
  List<Sport> get sports => _sports;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SearchViewModel() {
    fetchSports();
  }

  Future<void> fetchSports() async {
    _isLoading = true;
    notifyListeners();
    _sports = await _sportRepository.getSports();
    _isLoading = false;
    notifyListeners();
  }
}