import 'package:isis3510_team32_flutter/models/sport_model.dart';

abstract class InitiationEvent {}

class InitiationNextStepEvent extends InitiationEvent {}

class InitiationPreviousStepEvent extends InitiationEvent {}

class InitiationNameEvent extends InitiationEvent {
  String name;
  InitiationNameEvent(this.name);
}

class InitiationAgeEvent extends InitiationEvent {
  DateTime birthDate;
  InitiationAgeEvent(this.birthDate);
}

class InitiationGenderEvent extends InitiationEvent {
  String gender;
  InitiationGenderEvent(this.gender);
}

class InitiationAddSportEvent extends InitiationEvent {
  SportModel sportLiked;
  InitiationAddSportEvent(this.sportLiked);
}

class InitiationRemoveSportEvent extends InitiationEvent {
  String sportId;
  InitiationRemoveSportEvent(this.sportId);
}

class InitiationClearEvent extends InitiationEvent {}
