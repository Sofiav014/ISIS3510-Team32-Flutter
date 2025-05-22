import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/core/booking_view_service.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';

import 'package:go_router/go_router.dart';

class RecommendedBookingCardWidget extends StatelessWidget {
  final BookingModel booking;
  final BookingRepository bookingRepository = BookingRepository();
  final BookingViewService bookingViewService = BookingViewService();

  RecommendedBookingCardWidget({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/booking_detail',
          extra: {
            'booking': booking,
            'selectedIndex': 2,
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: AppColors.primary,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
              child: CachedNetworkImage(
                imageUrl: booking.venue.image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                    child: SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: CircularProgressIndicator(),
                )),
                errorWidget: (context, url, error) => const Center(
                    child: SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: Icon(Icons.broken_image),
                )),
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
      ),
    );
  }
}
