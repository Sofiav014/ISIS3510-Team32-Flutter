import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/core/booking_view_service.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';

class BookingInfo extends StatelessWidget {
  final BookingModel booking;
  final int selectedIndex;

  final BookingRepository bookingRepository = BookingRepository();
  final BookingViewService bookingViewService = BookingViewService();

  BookingInfo({super.key, required this.booking, required this.selectedIndex});

  String _truncateText(String text, int? maxLength) {
    if (maxLength == null || text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  void _processJoinBookingInBackground(
      BuildContext context, BookingModel booking) async {
    try {
      final result = await bookingRepository.joinBookingIsolate(
        booking: booking,
        user: context.read<AuthBloc>().state.userModel!,
        authBloc: context.read<AuthBloc>(),
      );


      final user = result['user'];

      final bookingUpdated = result['booking'];


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

        if (bookingUpdated != null) {
          bookingViewService.recordView('Booking Detail View');
          context.push('/booking_detail', extra: {
            'booking': booking,
            'selectedIndex': selectedIndex,
          });
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
    final authBloc = context.read<AuthBloc>();

    final userId = authBloc.state.user!.uid;
    final booked = booking.users.contains(userId);

    final venue = booking.venue;
    final durationMinutes =
        booking.endTime.difference(booking.startTime).inMinutes;

    final now = DateTime.now();
    String state;
    if (now.isBefore(booking.startTime)) {
      state = 'Upcoming';
    } else if (now.isAfter(booking.endTime)) {
      state = 'Finished';
    } else {
      state = 'In Progress';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date row
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/navbar/calendar.svg',
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const ColorFilter.mode(
                            AppColors.contrast900, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        DateFormat('d MMMM', 'en_US').format(booking.startTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Location row
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/location.svg',
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const ColorFilter.mode(
                            AppColors.contrast900, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        _truncateText(venue.locationName, 30),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Time row
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/clock.svg',
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const ColorFilter.mode(
                            AppColors.contrast900, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${DateFormat('HH:mm').format(booking.startTime)} h ($durationMinutes minutes)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // People row
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/people.svg',
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const ColorFilter.mode(
                            AppColors.contrast900, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${booking.users.length} / ${booking.maxUsers}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.contrast900,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    state,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (state == 'Upcoming')
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (booked) {
                    // Cancel booking
                    // _processCancelBookingInBackground(context, booking);
                  } else {
                    // Join booking
                    _processJoinBookingInBackground(context, booking);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      booked ? Colors.redAccent : Colors.greenAccent,
                  foregroundColor:
                      booked ? AppColors.contrast900 : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                ),
                child: Text(
                  booked ? 'Cancel Booking' : 'Join Booking',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
