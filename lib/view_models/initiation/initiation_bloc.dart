import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_state.dart';

class InitiationBloc extends Bloc<InitiationEvent, InitiationState> {
  InitiationBloc() : super(InitiationState()) {
    on<InitiationNameEvent>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<InitiationAgeEvent>((event, emit) {
      emit(state.copyWith(age: event.age));
    });
    on<InitiationGenderEvent>((event, emit) {
      emit(state.copyWith(sex: event.gender));
    });
    on<InitiationSportsEvent>((event, emit) {
      emit(state.copyWith(sportsLiked: event.sportsLiked));
    });
  }
}
