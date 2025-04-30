import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/core/screen_time.service.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_event.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_event.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_state.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_event.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_view/icon_selection_button_widget.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_view/initiation_date_picker_widget.dart';
import 'package:isis3510_team32_flutter/widgets/initiation_view/initiation_icon_toggle_button_widget.dart';

class InitiationView extends StatelessWidget {
  final ScreenTimeService screenTimeService;

  const InitiationView({super.key, required this.screenTimeService});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Initiation View');

    screenTimeService.startTrackingTime();

    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    final isHorizontal = aspectRatio > 1.2;
    final double topPadding = isHorizontal ? 16 : 144;

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
              top: topPadding,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  topPadding -
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
                          children: [
                            const InitiationNameView(),
                            const InititationGenderView(),
                            const InititationAgeView(),
                            InitiationSportView(
                              screenTimeService: screenTimeService,
                            ),
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

class InitiationNameView extends StatefulWidget {
  const InitiationNameView({super.key});

  @override
  State<InitiationNameView> createState() => _InitiationNameViewState();
}

class _InitiationNameViewState extends State<InitiationNameView> {
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
    final initiationBloc = context.read<InitiationBloc>();

    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;
    final isHorizontal = aspectRatio > 1.2;
    final double spacingBetweenButton = isHorizontal ? 32 : 128;
    final double spacingBetweenQuestion = isHorizontal ? 32 : 64;

    final displayName =
        context.select((AuthBloc bloc) => bloc.state.user?.displayName ?? "");

    // Set controller text if it's empty and displayName is available
    if (_nameController.text.isEmpty && displayName.isNotEmpty) {
      _nameController.text = displayName;
    }

    return Center(
      child: Form(
        child: Column(
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
                SizedBox(
                  height: spacingBetweenQuestion,
                ),
                const Text(
                  "What is your name?",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: spacingBetweenButton,
                ),
                SizedBox(
                  width: 256,
                  child: TextFormField(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
              ),
              onPressed: () {
                initiationBloc.add(InitiationNameEvent(_nameController.text));
                initiationBloc.add(InitiationNextStepEvent());
              },
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InititationGenderView extends StatelessWidget {
  const InititationGenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();

    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    final isHorizontal = aspectRatio > 1.2;
    final double spacingBetweenButton = isHorizontal ? 32 : 128;
    final double spacingBetweenQuestion = isHorizontal ? 32 : 64;

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
        SizedBox(
          height: spacingBetweenQuestion,
        ),
        const Text(
          "What gender do you identify with?",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: spacingBetweenButton,
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
  final ScreenTimeService screenTimeService;
  const InitiationSportView({super.key, required this.screenTimeService});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();
    final authBloc = context.read<AuthBloc>();
    final loadingBloc = context.read<LoadingBloc>();
    final connectivityBloc = context.read<ConnectivityBloc>();

    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    final isHorizontal = aspectRatio > 1.2;

    final gridRowLength = isHorizontal ? 4 : 2;
    final double imageSize = isHorizontal ? 48 : 96;
    final double textSize = isHorizontal ? 0 : 16;
    final double iconSpacing = isHorizontal ? 0 : 4;
    final double spacingBetweenQuestion = isHorizontal ? 32 : 64;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          !previous.hasModel && current.hasModel && current.user != null,
      listener: (context, state) {
        context.go("/home");
        initiationBloc.add(InitiationClearEvent());
        loadingBloc.add(HideLoadingEvent());
      },
      child: Center(
        child: Column(
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
                SizedBox(
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
                    crossAxisCount: gridRowLength,
                    shrinkWrap: true,
                    mainAxisSpacing: 10.0, // Spacing between rows
                    crossAxisSpacing: 10.0, // Spacing between columns
                    padding: const EdgeInsets.all(
                        10.0), // Padding around the entire grid
                    children: [
                      InitiationIconSelectionToggle(
                        text: "Basketball",
                        imageAsset:
                            "assets/icons/initiation/basketball-logo.svg",
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
                        imageAsset:
                            "assets/icons/initiation/volleyball-logo.svg",
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
            Builder(builder: (context) {
              final initiationState = context.watch<InitiationBloc>().state;
              final connectivityState = context.watch<ConnectivityBloc>().state;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 96, vertical: 16),
                ),
                onPressed: initiationState.sportsLiked.isNotEmpty
                    ? () async {
                        if (connectivityState is ConnectivityOfflineState) {
                          showNoConnectionError(context);
                          connectivityBloc
                              .add(ConnectivityRequestedFetchEvent());
                          return;
                        }

                        await screenTimeService
                            .stopAndRecordTime('Initiation View');

                        loadingBloc.add(ShowLoadingEvent());
                        authBloc.add(
                          AuthCreateModelEvent(
                            UserModel(
                              id: authBloc.state.user!.uid,
                              name: initiationBloc.state.name!,
                              birthDate: initiationBloc.state.birthDate!,
                              gender: initiationBloc.state.gender!,
                              sportsLiked: initiationBloc.state.sportsLiked,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "Create an account",
                  style: TextStyle(color: Colors.white),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
