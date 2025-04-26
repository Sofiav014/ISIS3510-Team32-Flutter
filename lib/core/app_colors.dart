import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_state.dart';

class AppColors {
  static ThemeState _theme(BuildContext context) =>
      context.watch<ThemeBloc>().state;

  static Color background(BuildContext context) =>
      _theme(context) is ThemeDarkState
          ? const Color(0xFF303030)
          : const Color(0xFFFFFFFF);

  static Color appBarBackground(BuildContext context) =>
      _theme(context) is ThemeDarkState
          ? const Color(0xFF60508C)
          : const Color(0xFFFFFFFF);

  static Color titleText(BuildContext context) =>
      _theme(context) is ThemeDarkState
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF60508C);

  static Color text(BuildContext context) => _theme(context) is ThemeDarkState
      ? const Color(0xFFE1DDEE)
      : const Color(0xFF070304);

  static Color border(BuildContext context) => _theme(context) is ThemeDarkState
      ? const Color(0xFF555555)
      : const Color(0xFFDDDDDD);

  static Color accent(BuildContext context) => _theme(context) is ThemeDarkState
      ? const Color(0xFFFBD1A2)
      : const Color(0xFF60508C);

  static const primary = Color(0xFF60508C); // Purple
  static const primaryNeutral = Color(0xFFFFFFFF); // White
  static const lightPurple = Color(0xFF6750A4); // Light Purple
  static const lighterPurple = Color(0xFF7D73A2); // Lighter Purple
  static const lightererPurple =
      Color(0xFF9C94B8); // Lighterer Purple, I'm out of names
  static const lightestPurple = Color(0xFFD6D2E0); // Lightest Purple
  static const contrast900 = Color(0xFFFBD1A2); // Light Peach
}
