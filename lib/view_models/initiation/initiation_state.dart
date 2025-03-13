import 'package:isis3510_team32_flutter/models/sport_model.dart';

class InitiationState {
  String? name;
  int? age;
  String? sex;
  List<SportModel> sportsLiked = [];

  InitiationState(
      {this.name, this.age, this.sex, List<SportModel>? sportsLiked})
      : sportsLiked = sportsLiked ?? [];

  InitiationState copyWith({
    String? name,
    int? age,
    String? sex,
    List<SportModel>? sportsLiked,
  }) {
    return InitiationState(
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      sportsLiked: sportsLiked ?? this.sportsLiked,
    );
  }
}
