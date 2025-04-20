import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/sport_model.dart';

class SportPopularityReportCardWidget extends StatelessWidget {
  final SportModel sport;
  final String title;
  final int sportPlayedCount;

  const SportPopularityReportCardWidget({
    super.key,
    required this.sport,
    required this.title,
    required this.sportPlayedCount
  });

  String getSportLogo(String sportId) {
    switch (sportId) {
      case 'basketball':
        return 'basketball-logo.svg';
      case 'football':
        return 'football-logo.svg';
      case 'volleyball':
        return 'volleyball-logo.svg';
      case 'tennis':
        return 'tennis-logo.svg';
      default:
        return 'basketball-logo.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 170.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: AppColors.lightPurple,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10.0),
              SvgPicture.asset(
                'assets/icons/initiation/${getSportLogo(sport.id)}',
                color: Colors.white,
                height: 50.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                sport.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                'Played $sportPlayedCount times',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
