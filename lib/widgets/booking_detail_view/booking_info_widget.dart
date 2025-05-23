import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/core/booking_view_service.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/booking_detail/booking_detail_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_event.dart';

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

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final loadingBloc = context.read<LoadingBloc>();
    final bookingDetailBloc = context.read<BookingDetailBloc>();

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
            child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
              builder: (context, connectivityState) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (connectivityState is ConnectivityOfflineState) {
                        showNoConnectionError(context);
                        return;
                      }

                      Map<String, dynamic> results = {};

                      if (booked) {
                        // Cancel booking
                        loadingBloc.add(ShowLoadingEvent());
                        results = await bookingRepository.cancelBooking(
                            booking: booking,
                            user: authBloc.state.userModel!,
                            authBloc: authBloc);
                        loadingBloc.add(HideLoadingEvent());
                      } else {
                        // Join booking
                        loadingBloc.add(ShowLoadingEvent());

                        results = await bookingRepository.joinBooking(
                            booking: booking,
                            user: authBloc.state.userModel!,
                            authBloc: authBloc);

                        loadingBloc.add(HideLoadingEvent());
                      }

                      if (results['status'] == 'success') {
                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (dialogContext) {
                            bool updated = false;
                            return WillPopScope(
                              onWillPop: () async {
                                if (!updated) {
                                  bookingDetailBloc.add(
                                    UpdateBooking(
                                      booking: results['booking'],
                                    ),
                                  );
                                  updated = true;
                                }
                                return true;
                              },
                              child: AlertDialog(
                                title: const Text('Join Booking'),
                                content: booked
                                    ? const Text(
                                        'You have successfully canceled your booking.')
                                    : const Text(
                                        'You have successfully joined the booking.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                      if (!updated) {
                                        bookingDetailBloc.add(
                                          UpdateBooking(
                                            booking: results['booking'],
                                          ),
                                        );
                                        updated = true;
                                      }
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (results['status'] == 'error') {
                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Join Booking'),
                              content: const Text(
                                  'Failed to join the booking. Please try again.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
