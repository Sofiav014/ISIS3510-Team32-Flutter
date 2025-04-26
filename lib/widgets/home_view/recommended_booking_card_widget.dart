import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class RecommendedBookingCardWidget extends StatelessWidget {
  final BookingModel booking;

  const RecommendedBookingCardWidget({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: AppColors.primaryLight,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
            child: Image.network(
              booking.venue.image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/navbar/calendar.svg',
                        width: 16,
                        height: 16,
                        color: AppColors.contrast900,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          DateFormat('dd MMMM').format(booking.startTime),
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/clock.svg',
                        width: 16,
                        height: 16,
                        color: AppColors.contrast900,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${DateFormat('HH:mm').format(booking.startTime)} h (${(booking.endTime.difference(booking.startTime).inMinutes)} minutes)',
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/people.svg',
                        width: 16,
                        height: 16,
                        color: AppColors.contrast900,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${booking.users.length} / ${booking.maxUsers}',
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
