import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_view/icon_selection_button_widget.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_view/initiation_date_picker_widget.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_view/initiation_icon_toggle_button_widget.dart';

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
    const double spacingBetweenButton = 128;
    const double spacingBetweenQuestion = 64;

    final displayName =
        context.select((AuthBloc bloc) => bloc.state.user?.displayName ?? "");

    // Set controller text if it's empty and displayName is available
    if (_nameController.text.isEmpty && displayName.isNotEmpty) {
      _nameController.text = displayName;
    }

    return Scaffold(
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
                    debugPrint(_nameController.value.text);
                    context.go('/profile');
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
    );
  }
}

class SettingsGenderView extends StatelessWidget {
  const SettingsGenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    debugPrint('male');
                    context.go('/profile');
                  },
                  size: 64,
                ),
                IconSelectionButton(
                  text: "Female",
                  imageAsset: "assets/icons/initiation/female.svg",
                  onPressed: () {
                    debugPrint('female');
                    context.go('/profile');
                  },
                  size: 64,
                ),
                IconSelectionButton(
                  text: "Other",
                  imageAsset: "assets/icons/initiation/non-binary.svg",
                  onPressed: () {
                    debugPrint('other');
                    context.go('/profile');
                  },
                  size: 64,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SettingsAgeView extends StatelessWidget {
  const SettingsAgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    final isHorizontal = aspectRatio > 1.2;
    final double spacingBetweenButton = isHorizontal ? 32 : 128;
    final double spacingBetweenQuestion = isHorizontal ? 32 : 64;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Great! Now, let’s move on to the next question",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: spacingBetweenQuestion,
            ),
            const Text(
              "When were you born?",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: spacingBetweenButton,
            ),
            const InitiationDatePicker(),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
          ),
          onPressed: () {},
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class SettingsSportView extends StatelessWidget {
  const SettingsSportView({super.key});

  @override
  Widget build(BuildContext context) {
    const double imageSize = 96;
    const double textSize = 16;
    const double iconSpacing = 4;
    const double spacingBetweenQuestion = 64;

    return Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "We want to know you better",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: spacingBetweenQuestion,
            ),
            const Text(
              "Choose the sports you are interested in",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
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
                  InitiationIconSelectionToggle(
                    text: "Basketball",
                    imageAsset: "assets/icons/initiation/basketball-logo.svg",
                    sport: initiationSports["basketball"]!,
                    size: imageSize,
                    spacing: iconSpacing,
                    textSize: textSize,
                  ),
                  InitiationIconSelectionToggle(
                    text: "Football",
                    imageAsset: "assets/icons/initiation/football-logo.svg",
                    sport: initiationSports["football"]!,
                    size: imageSize,
                    spacing: iconSpacing,
                    textSize: textSize,
                  ),
                  InitiationIconSelectionToggle(
                    text: "Volleyball",
                    imageAsset: "assets/icons/initiation/volleyball-logo.svg",
                    sport: initiationSports["volleyball"]!,
                    size: imageSize,
                    spacing: iconSpacing,
                    textSize: textSize,
                  ),
                  InitiationIconSelectionToggle(
                    text: "Tennis",
                    imageAsset: "assets/icons/initiation/tennis-logo.svg",
                    sport: initiationSports["tennis"]!,
                    spacing: iconSpacing,
                    size: imageSize,
                    textSize: textSize,
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
            padding: const EdgeInsets.symmetric(horizontal: 96, vertical: 16),
          ),
          onPressed: () {},
          child: const Text(
            "Create an account",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }
}
