import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/sport_model.dart';
import 'package:go_router/go_router.dart';

class SportButtonWidget extends StatelessWidget {
  final String text;
  final String imageAsset;
  final double size;
  final SportModel sport;

  const SportButtonWidget({
    required this.text,
    required this.imageAsset,
    required this.size,
    required this.sport,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.primary.withAlpha(990),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      onPressed: () {
        context.go('/venue_list/${sport.name}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        child: Column(
          children: [
            SvgPicture.asset(
              imageAsset,
              width: size,
              height: size,
              color: Colors.white,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(text,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            )
          ],
        ),
      ),
    );
  }
}