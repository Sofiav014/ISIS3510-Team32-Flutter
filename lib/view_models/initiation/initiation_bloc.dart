import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isis3510_team32_flutter/models/sport_model.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_state.dart';

class InitiationBloc extends HydratedBloc<InitiationEvent, InitiationState> {
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

  @override
  InitiationState? fromJson(Map<String, dynamic> json) {
    return InitiationState(
      name: json['name'] as String?,
      birthDate: json['birthDate']
          as DateTime?, // or DateTime.parse if it's a DateTime
      gender: json['gender'] as String?,
      sportsLiked: List<SportModel>.from(json['sportsLiked'] ?? []),
      currentStep: json['currentStep'] as int,
    );
  }

  @override
  Map<String, dynamic>? toJson(InitiationState state) {
    return {
      'name': state.name,
      'birthDate': state.birthDate,
      'gender': state.gender,
      'sportsLiked': state.sportsLiked,
      'currentStep': state.currentStep,
    };
  }
}
