import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_event.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeLightState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    on<ThemeSwitchEvent>((event, emit) async {
      emit(state is ThemeLightState ? ThemeDarkState() : ThemeLightState());
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final theme = json["theme"];
    return theme == "light" ? ThemeLightState() : ThemeDarkState();
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      "theme": state is ThemeLightState ? "light" : "dark",
    };
  }
}
