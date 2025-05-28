import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/core/booking_view_service.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';

class BookingInfoCard extends StatelessWidget {
  final VenueModel venue;
  final BookingModel booking;
  final BookingRepository bookingRepository = BookingRepository();
  final BookingViewService bookingViewService = BookingViewService();

  BookingInfoCard({super.key, required this.venue, required this.booking});

  String _truncateText(String text, int? maxLength) {
    if (maxLength == null || text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/booking_detail',
          extra: {
            'booking': booking,
            'selectedIndex': 0,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      width: 16.0,
                      height: 16.0,
                      colorFilter: const ColorFilter.mode(
                          AppColors.contrast900, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      _truncateText(venue.locationName, 30),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/people.svg',
                      width: 16.0,
                      height: 16.0,
                      colorFilter: const ColorFilter.mode(
                          AppColors.contrast900, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${booking.users.length}/${booking.maxUsers}',
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/clock.svg',
                      width: 16.0,
                      height: 16.0,
                      colorFilter: const ColorFilter.mode(
                          AppColors.contrast900, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${DateFormat('HH:mm').format(booking.startTime)} - ${DateFormat('HH:mm').format(booking.endTime)}',
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
