import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isis3510_team32_flutter/core/theme_frecuency_service.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_event.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeFrecuencyService themeFrecuencyService;

  ThemeBloc({required this.themeFrecuencyService}) : super(ThemeLightState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    on<ThemeSwitchEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final bool? hasChangedBefore = prefs.getBool('userHasChangedTheme');
      if (hasChangedBefore == null) {
        await prefs.setBool('userHasChangedTheme', true);
        themeFrecuencyService.recordThemeChangeStatus(false);
      }
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
