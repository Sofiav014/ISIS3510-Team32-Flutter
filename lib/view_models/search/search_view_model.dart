import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/models/sport_model.dart';

class SearchViewModel extends ChangeNotifier {
  List<SportModel> _sports = [];
  List<SportModel> get sports => _sports;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SearchViewModel() {
    fetchSports();
  }

  Future<void> fetchSports() async {
    _isLoading = true;
    notifyListeners();
    _sports = initiationSports.values.toList();
    _isLoading = false;
    notifyListeners();
  }
}