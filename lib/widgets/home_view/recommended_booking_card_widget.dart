import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';
import 'package:isis3510_team32_flutter/view_models/home/home_bloc.dart';

class RecommendedBookingCardWidget extends StatelessWidget {
  final BookingModel booking;
  final BookingRepository bookingRepository = BookingRepository();

  RecommendedBookingCardWidget({
    super.key,
    required this.booking,
  });

  // This method is placed inside the widget class
  void _processBookingInBackground(
      BuildContext context, BookingModel booking) async {
    // Show loading indicator (optional, but can be helpful)
    try {
      // Call the existing joinBookingIsolate method from the repository
      final user = await bookingRepository.joinBookingIsolate(
        booking: booking,
        user: context.read<AuthBloc>().state.userModel!,
        authBloc: context.read<AuthBloc>(),
      );

      // Show the SnackBar after the isolate operation completes
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
          context.read<HomeBloc>().add(const LoadHomeData());
        }
      }
    } catch (e) {
      // Handle errors if any
      debugPrint('Error: $e');
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

                    // Show "Your booking is being processed" message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your booking is being processed...'),
                        duration: Duration(seconds: 2), // Message duration
                      ),
                    );

                    _processBookingInBackground(context, booking);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
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
