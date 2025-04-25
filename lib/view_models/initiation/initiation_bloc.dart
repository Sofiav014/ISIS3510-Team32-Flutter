import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isis3510_team32_flutter/models/data_models/sport_model.dart';
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
    on<InitiationClearEvent>((event, emit) {
      emit(InitiationState());
    });
  }

  @override
  InitiationState? fromJson(Map<String, dynamic> json) {
    return InitiationState(
      name: json['name'] as String?,
      birthDate:
          json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'] as String?,
      sportsLiked: (json['sportsLiked'] as List<dynamic>?)
              ?.map((e) => SportModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentStep: json['currentStep'] as int,
    );
  }

  @override
  Map<String, dynamic>? toJson(InitiationState state) {
    return {
      'name': state.name,
      'birthDate': state.birthDate?.toIso8601String(),
      'gender': state.gender,
      'sportsLiked':
          state.sportsLiked.map((sportLiked) => sportLiked.toJson()).toList(),
      'currentStep': state.currentStep,
    };
  }
}
