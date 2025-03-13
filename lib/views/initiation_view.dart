import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';

class InitiationView extends StatelessWidget {
  const InitiationView({super.key});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();

    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 144,
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Let us begin with a couple of questions",
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
                "What gender do you identify with?",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 128,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GenderSelectionButton(
                      text: "Male",
                      imageAsset: "assets/icons/initiation/male.svg",
                      onPressed: null),
                  GenderSelectionButton(
                      text: "Female",
                      imageAsset: "assets/icons/initiation/female.svg",
                      onPressed: null),
                  GenderSelectionButton(
                      text: "Other",
                      imageAsset: "assets/icons/initiation/non-binary.svg",
                      onPressed: null),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GenderSelectionButton extends StatelessWidget {
  final String text;
  final String imageAsset;
  final Function(String)? onPressed;

  const GenderSelectionButton(
      {required this.text,
      required this.imageAsset,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      onPressed: onPressed != null ? () => onPressed!.call(text) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          children: [
            SvgPicture.asset(
              imageAsset,
              width: 64,
              height: 64,
              color: AppColors.primary,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
