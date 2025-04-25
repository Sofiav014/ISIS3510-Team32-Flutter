import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_event.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeLightState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    on<ThemeSwitchEvent>((event, emit) async {
      emit(state is ThemeLightState ? ThemeDarkState() : ThemeLightState());
    });
  }
}
