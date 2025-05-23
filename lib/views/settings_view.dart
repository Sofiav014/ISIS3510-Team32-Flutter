import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/data_models/sport_model.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_event.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_event.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_view/icon_selection_button_widget.dart';

class SettingsNameView extends StatefulWidget {
  const SettingsNameView({super.key});

  @override
  State<SettingsNameView> createState() => _SettingsNameViewState();
}

class _SettingsNameViewState extends State<SettingsNameView> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        context.select((AuthBloc bloc) => bloc.state.userModel?.name ?? "");

    // Set controller text if it's empty and model name is available
    if (_nameController.text.isEmpty && displayName.isNotEmpty) {
      _nameController.text = displayName;
    }

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.userModel?.name != current.userModel?.name,
      listener: (context, state) {
        context.read<LoadingBloc>().add(HideLoadingEvent());
        context.go('/profile');
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 64, top: 192),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: Text(
                          "Edit Profile Name",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 64),
                        child: Text(
                          "Please insert your new name",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 256,
                        child: TextField(
                          controller: _nameController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(35),
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ '\-]"))
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 128, vertical: 16),
                    ),
                    onPressed: () {
                      context.read<LoadingBloc>().add(ShowLoadingEvent());
                      context.read<AuthBloc>().add(
                            AuthUpdateModelEvent(name: _nameController.text),
                          );
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsGenderView extends StatelessWidget {
  const SettingsGenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.userModel?.gender != current.userModel?.gender,
      listener: (context, state) {
        context.read<LoadingBloc>().add(HideLoadingEvent());
        context.go('/profile');
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 192),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 64),
                child: Text(
                  "Change Gender",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 128),
                child: Text(
                  "What gender do you identify with?",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconSelectionButton(
                    text: "Male",
                    imageAsset: "assets/icons/initiation/male.svg",
                    onPressed: () {
                      context.read<LoadingBloc>().add(ShowLoadingEvent());
                      context.read<AuthBloc>().add(
                            AuthUpdateModelEvent(gender: "Male"),
                          );
                    },
                    size: 64,
                  ),
                  IconSelectionButton(
                    text: "Female",
                    imageAsset: "assets/icons/initiation/female.svg",
                    onPressed: () {
                      context.read<LoadingBloc>().add(ShowLoadingEvent());
                      context.read<AuthBloc>().add(
                            AuthUpdateModelEvent(gender: "Female"),
                          );
                    },
                    size: 64,
                  ),
                  IconSelectionButton(
                    text: "Other",
                    imageAsset: "assets/icons/initiation/non-binary.svg",
                    onPressed: () {
                      context.read<LoadingBloc>().add(ShowLoadingEvent());
                      context.read<AuthBloc>().add(
                            AuthUpdateModelEvent(gender: "Other"),
                          );
                    },
                    size: 64,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsAgeView extends StatefulWidget {
  const SettingsAgeView({super.key});

  @override
  State<SettingsAgeView> createState() => _SettingsAgeViewState();
}

class _SettingsAgeViewState extends State<SettingsAgeView> {
  DateTime? _dateTime;

  Future<DateTime?> _selectDate() async => showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 365 * 14)),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now().subtract(const Duration(days: 365 * 14)),
      ).then((DateTime? selected) {
        return selected;
      });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.userModel?.birthDate != current.userModel?.birthDate,
      listener: (context, state) {
        context.read<LoadingBloc>().add(HideLoadingEvent());
        context.go('/profile');
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 192, bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 64),
                    child: Text(
                      "Update Birth Date",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 128),
                    child: Text(
                      "When were you born?",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final setDateTime = await _selectDate();
                            setState(() {
                              _dateTime = setDateTime;
                            });
                          },
                          child: Text(
                            _dateTime == null
                                ? 'Select a date'
                                : "${_dateTime!.year}/${_dateTime!.month}/${_dateTime!.day}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
                ),
                onPressed: () {
                  context.read<LoadingBloc>().add(ShowLoadingEvent());
                  context.read<AuthBloc>().add(
                        AuthUpdateModelEvent(birthDate: _dateTime),
                      );
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSportView extends StatefulWidget {
  const SettingsSportView({super.key});

  @override
  State<SettingsSportView> createState() => _SettingsSportViewState();
}

class _SettingsSportViewState extends State<SettingsSportView> {
  List<SportModel> _sportModels = [];

  void modifySportModels(SportModel model, bool shouldAdd) {
    final newSportModels = List<SportModel>.from(_sportModels);
    if (shouldAdd) {
      newSportModels.add(model);
    } else {
      newSportModels.remove(model);
    }
    setState(() {
      _sportModels = newSportModels;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double imageSize = 96;
    const double textSize = 16;
    const double iconSpacing = 4;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.userModel?.sportsLiked != current.userModel?.sportsLiked,
      listener: (context, state) {
        context.read<LoadingBloc>().add(HideLoadingEvent());
        context.go('/profile');
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 192, bottom: 32),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 64),
                        child: Text(
                          "Update Sports",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: Text(
                          "Choose the sports you are interested in",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 10.0, // Spacing between rows
                          crossAxisSpacing: 10.0, // Spacing between columns
                          padding: const EdgeInsets.all(
                              10.0), // Padding around the entire grid
                          children: [
                            SettingsIconSelectionToggle(
                              text: "Basketball",
                              imageAsset:
                                  "assets/icons/initiation/basketball-logo.svg",
                              sport: initiationSports["basketball"]!,
                              size: imageSize,
                              spacing: iconSpacing,
                              textSize: textSize,
                              onPress: (status) => modifySportModels(
                                  initiationSports["basketball"]!, status),
                            ),
                            SettingsIconSelectionToggle(
                              text: "Football",
                              imageAsset:
                                  "assets/icons/initiation/football-logo.svg",
                              sport: initiationSports["football"]!,
                              size: imageSize,
                              spacing: iconSpacing,
                              textSize: textSize,
                              onPress: (status) => modifySportModels(
                                  initiationSports["football"]!, status),
                            ),
                            SettingsIconSelectionToggle(
                              text: "Volleyball",
                              imageAsset:
                                  "assets/icons/initiation/volleyball-logo.svg",
                              sport: initiationSports["volleyball"]!,
                              size: imageSize,
                              spacing: iconSpacing,
                              textSize: textSize,
                              onPress: (status) => modifySportModels(
                                  initiationSports["volleyball"]!, status),
                            ),
                            SettingsIconSelectionToggle(
                              text: "Tennis",
                              imageAsset:
                                  "assets/icons/initiation/tennis-logo.svg",
                              sport: initiationSports["tennis"]!,
                              spacing: iconSpacing,
                              size: imageSize,
                              textSize: textSize,
                              onPress: (status) => modifySportModels(
                                  initiationSports["tennis"]!, status),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 96, vertical: 16),
                    ),
                    onPressed: () {
                      context.read<LoadingBloc>().add(ShowLoadingEvent());
                      context.read<AuthBloc>().add(
                            AuthUpdateModelEvent(sportsLiked: _sportModels),
                          );
                    },
                    child: const Text(
                      "Create an account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class SettingsIconSelectionToggle extends StatefulWidget {
  final String text;
  final String imageAsset;
  final double size;
  final double textSize;
  final double spacing;
  final SportModel sport;
  final Function(bool) onPress;

  const SettingsIconSelectionToggle({
    required this.text,
    required this.imageAsset,
    required this.size,
    required this.textSize,
    required this.spacing,
    required this.sport,
    required this.onPress,
    super.key,
  });

  @override
  State<SettingsIconSelectionToggle> createState() =>
      _SettingsIconSelectionToggleState();
}

class _SettingsIconSelectionToggleState
    extends State<SettingsIconSelectionToggle> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
            selected ? AppColors.primary.withValues(alpha: 0.3) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      onPressed: () {
        widget.onPress(!selected);
        setState(() {
          selected = !selected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          children: [
            SvgPicture.asset(
              widget.imageAsset,
              width: widget.size,
              height: widget.size,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(
              height: widget.spacing,
            ),
            Text(
              widget.text,
              style: TextStyle(fontSize: widget.textSize),
            )
          ],
        ),
      ),
    );
  }
}
