import 'package:isis3510_team32_flutter/models/sport_model.dart';

class InitiationState {
  String? name;
  DateTime? birthDate;
  String? gender;
  List<SportModel> sportsLiked = [];
  int currentStep;

  InitiationState({
    this.name,
    this.birthDate,
    this.gender,
    List<SportModel>? sportsLiked,
    this.currentStep = 0,
  }) : sportsLiked = sportsLiked ?? [];

  InitiationState copyWith({
    String? name,
    DateTime? birthDate,
    String? gender,
    List<SportModel>? sportsLiked,
    int? currentStep,
  }) {
    return InitiationState(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      sportsLiked: sportsLiked ?? this.sportsLiked,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
