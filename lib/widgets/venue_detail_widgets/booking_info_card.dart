import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/core/booking_view_service.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/home/home_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/venue_detail/venue_detail_bloc.dart';

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

  void _processBookingInBackground(
      BuildContext context, BookingModel booking, VenueModel venue) async {
    try {
      final user = await bookingRepository.joinBookingFromVenueIsolate(
        booking: booking,
        user: context.read<AuthBloc>().state.userModel!,
        venue: venue,
        authBloc: context.read<AuthBloc>(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              user != null
                  ? 'Successfully joined the booking!'
                  : 'Failed to join the booking.',
            ),
          ),
        );

        if (user != null) {
          bookingViewService.recordView('Venue Detail View');
          context
              .read<VenueDetailBloc>()
              .add(LoadVenueDetailData(venueId: venue.id));
          context.read<HomeBloc>().add(const LoadHomeData());
        }
      }
    } catch (e) {
      debugPrint('❗️ Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred while processing the booking.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConnectivityBloc connectivityBloc = context.read<ConnectivityBloc>();

    return GestureDetector(
      onTap: () {
        final connectivityState = connectivityBloc.state;

        if (connectivityState is ConnectivityOfflineState) {
          showNoConnectionError(context);
          return;
        }

        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Join Booking'),
              content: const Text('Do you want to join this booking?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    final connectivityState = connectivityBloc.state;

                    if (connectivityState is ConnectivityOfflineState) {
                      Navigator.of(dialogContext).pop();
                      showNoConnectionErrorJoinBooking(context);
                      return;
                    }

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your booking is being processed...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    _processBookingInBackground(context, booking, venue);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
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
                      color: AppColors.contrast900,
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
                      color: AppColors.contrast900,
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
                      color: AppColors.contrast900,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${DateFormat('HH:mm').format(booking.startTime)} - ${DateFormat('HH:mm').format(booking.endTime)}',
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/navbar/calendar.svg',
                      width: 16.0,
                      height: 16.0,
                      color: AppColors.contrast900,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      DateFormat('MMM dd').format(booking.startTime),
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
