import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_state.dart';

class InitiationBloc extends Bloc<InitiationEvent, InitiationState> {
  InitiationBloc() : super(InitiationState()) {
    on<InitiationNameEvent>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<InitiationAgeEvent>((event, emit) {
      emit(state.copyWith(birthDate: event.birthDate));
    });
    on<InitiationGenderEvent>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });
    on<InitiationAddSportEvent>((event, emit) {
      emit(state.copyWith(
        sportsLiked: [...state.sportsLiked, event.sportLiked],
      ));
    });
    on<InitiationRemoveSportEvent>((event, emit) {
      emit(state.copyWith(
        sportsLiked: [...state.sportsLiked]
            .where((sport) => sport.id != event.sportId)
            .toList(),
      ));
    });
    on<InitiationNextStepEvent>((event, emit) {
      if (state.currentStep < 3) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });
    on<InitiationPreviousStepEvent>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });
  }
}
