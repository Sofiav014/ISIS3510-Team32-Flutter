import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/data_models/sport_model.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_state.dart';

class InitiationIconSelectionToggle extends StatelessWidget {
  final String text;
  final String imageAsset;
  final double size;
  final double textSize;
  final double spacing;
  final SportModel sport;

  const InitiationIconSelectionToggle({
    required this.text,
    required this.imageAsset,
    required this.size,
    required this.textSize,
    required this.spacing,
    required this.sport,
    super.key,
  });

  bool sportIsSelected(InitiationState state) {
    return state.sportsLiked.any((likedSport) => likedSport.id == sport.id);
  }

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();

    return BlocBuilder<InitiationBloc, InitiationState>(
      builder: (context, state) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: sportIsSelected(state)
              ? AppColors.primary.withOpacity(0.3)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        onPressed: () {
          if (!sportIsSelected(state)) {
            initiationBloc.add(InitiationAddSportEvent(sport));
          } else {
            initiationBloc.add(InitiationRemoveSportEvent(sport.id));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Column(
            children: [
              SvgPicture.asset(
                imageAsset,
                width: size,
                height: size,
                color: AppColors.primary,
              ),
              SizedBox(
                height: spacing,
              ),
              Text(
                text,
                style: TextStyle(fontSize: textSize),
              )
            ],
          ),
        ),
      ),
    );
  }
}
