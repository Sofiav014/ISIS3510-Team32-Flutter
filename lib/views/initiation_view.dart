import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_state.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_date_picker_widget.dart';
import 'package:isis3510_team32_flutter/widgets/icon_selection_button_widget.dart';

import '../widgets/initiation_icon_toggle_button_widget.dart';

class InitiationView extends StatelessWidget {
  const InitiationView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final initiationBloc = context.read<InitiationBloc>();

        if (initiationBloc.state.currentStep > 0) {
          initiationBloc.add(InitiationPreviousStepEvent());
        } else {
          Navigator.of(context).pop(result);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 144,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  144 -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  32,
              child: BlocBuilder<InitiationBloc, InitiationState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: state.currentStep,
                          children: const [
                            InitiationNameView(),
                            InititationGenderView(),
                            InititationAgeView(),
                            InitiationSportView(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InitiationNameView extends StatelessWidget {
  const InitiationNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();
    final authBloc = context.read<AuthBloc>();
    final TextEditingController controller =
        TextEditingController(text: authBloc.state.user!.displayName ?? "");

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Let us begin with a couple of questions",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 64,
            ),
            const Text(
              "What is your name?",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 128,
            ),
            SizedBox(
              width: 256,
              child: TextFormField(
                controller: controller,
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
            padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
          ),
          onPressed: () {
            initiationBloc.add(InitiationNameEvent(controller.text));
            initiationBloc.add(InitiationNextStepEvent());
          },
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class InititationGenderView extends StatelessWidget {
  const InititationGenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Let us begin with a couple of questions",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 64,
        ),
        const Text(
          "What gender do you identify with?",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 128,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconSelectionButton(
              text: "Male",
              imageAsset: "assets/icons/initiation/male.svg",
              onPressed: () {
                initiationBloc.add(InitiationGenderEvent("Male"));
                initiationBloc.add(InitiationNextStepEvent());
              },
              size: 64,
            ),
            IconSelectionButton(
              text: "Female",
              imageAsset: "assets/icons/initiation/female.svg",
              onPressed: () {
                initiationBloc.add(InitiationGenderEvent("Female"));
                initiationBloc.add(InitiationNextStepEvent());
              },
              size: 64,
            ),
            IconSelectionButton(
              text: "Other",
              imageAsset: "assets/icons/initiation/non-binary.svg",
              onPressed: () {
                initiationBloc.add(InitiationGenderEvent("Other"));
                initiationBloc.add(InitiationNextStepEvent());
              },
              size: 64,
            ),
          ],
        )
      ],
    );
  }
}

class InititationAgeView extends StatelessWidget {
  const InititationAgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Great! Now, let’s move on to the next question",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 64,
            ),
            Text(
              "When were you born?",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 128,
            ),
            InitiationDatePicker(),
          ],
        ),
        BlocBuilder<InitiationBloc, InitiationState>(
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
              ),
              onPressed: state.birthDate != null
                  ? () {
                      initiationBloc.add(InitiationNextStepEvent());
                    }
                  : null,
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        )
      ],
    );
  }
}

class InitiationSportView extends StatelessWidget {
  const InitiationSportView({super.key});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();
    final authBloc = context.read<AuthBloc>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
              height: 64,
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
                crossAxisCount: 2, // Creates a grid with 2 columns
                shrinkWrap:
                    true, // Use this if the grid is inside another scrollable widget
                mainAxisSpacing: 10.0, // Spacing between rows
                crossAxisSpacing: 10.0, // Spacing between columns
                padding: const EdgeInsets.all(
                    10.0), // Padding around the entire grid
                children: [
                  InitiationIconSelectionToggle(
                    text: "Basketball",
                    imageAsset: "assets/icons/initiation/basketball-logo.svg",
                    sport: initiationSports["basketball"]!,
                    size: 96,
                  ),
                  InitiationIconSelectionToggle(
                    text: "Football",
                    imageAsset: "assets/icons/initiation/football-logo.svg",
                    sport: initiationSports["football"]!,
                    size: 96,
                  ),
                  InitiationIconSelectionToggle(
                    text: "Volleyball",
                    imageAsset: "assets/icons/initiation/volleyball-logo.svg",
                    sport: initiationSports["volleyball"]!,
                    size: 96,
                  ),
                  InitiationIconSelectionToggle(
                    text: "Tennis",
                    imageAsset: "assets/icons/initiation/tennis-logo.svg",
                    sport: initiationSports["tennis"]!,
                    size: 96,
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
            padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
          ),
          onPressed: () {
            authBloc.add(AuthCreateModelEvent(UserModel(
              id: authBloc.state.user!.uid,
              name: initiationBloc.state.name!,
              birthDate: initiationBloc.state.birthDate!,
              gender: initiationBloc.state.gender!,
              sportsLiked: initiationBloc.state.sportsLiked,
            )));
          },
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
