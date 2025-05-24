import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/settings/settings_event.dart';
import 'package:isis3510_team32_flutter/view_models/settings/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<StartSettingsEvent>((event, emit) {
      emit(SettingsInProgress());
    });
    on<FinishSettingsEvent>((event, emit) {
      emit(SettingsComplete());
    });
    on<ResetSettingsEvent>((event, emit) {
      emit(SettingsInitial());
    });
  }
}
