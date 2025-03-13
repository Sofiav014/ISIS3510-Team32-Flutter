import 'package:isis3510_team32_flutter/models/sport_model.dart';

abstract class InitiationEvent {}

class InitiationNameEvent extends InitiationEvent {
  String name;
  InitiationNameEvent(this.name);
}

class InitiationAgeEvent extends InitiationEvent {
  int age;
  InitiationAgeEvent(this.age);
}

class InitiationGenderEvent extends InitiationEvent {
  String gender;
  InitiationGenderEvent(this.gender);
}

class InitiationSportsEvent extends InitiationEvent {
  List<SportModel> sportsLiked;
  InitiationSportsEvent(this.sportsLiked);
}
