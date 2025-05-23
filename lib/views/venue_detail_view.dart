import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/venue_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/venue_detail/venue_detail_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/widgets/venue_detail_widgets/booking_info_card.dart';
import 'package:isis3510_team32_flutter/widgets/venue_detail_widgets/venue_detail_image_widget.dart';

class VenueDetailView extends StatelessWidget {
  final String sportId;
  final String venueId;

  const VenueDetailView(
      {super.key, required this.sportId, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    FirebaseCrashlytics.instance
        .setCustomKey('screen', 'Venue $sportId detail View');

    return BlocProvider(
        create: (context) => VenueDetailBloc(
            venueRepository: VenueRepository(),
            connectivityRepository: ConnectivityRepository(),
            venueId: venueId,
            authBloc: authBloc)
          ..add(LoadVenueDetailData(venueId: venueId)),
        child: Scaffold(
          backgroundColor: AppColors.background(context),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.titleText(context)),
              onPressed: () {
                context.push('/venue_list/$sportId');
              },
            ),
            title: Text('Venue Detail',
                style: TextStyle(
                  color: AppColors.titleText(context),
                  fontWeight: FontWeight.w600,
                )),
            centerTitle: true,
            backgroundColor: AppColors.appBarBackground(context),
            shadowColor: AppColors.text(context),
            elevation: 1,
          ),
          body: BlocListener<VenueDetailBloc, VenueDetailState>(
            listener: (context, state) {
              if (state is VenueDetailOfflineLoaded) {
                showNoConnectionError(context);
              }
            },
            child: BlocBuilder<VenueDetailBloc, VenueDetailState>(
              builder: (context, state) {
                if (state is VenueDetailLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VenueDetailLoaded) {
                  final VenueModel venue = state.venue;
                  final List<BookingModel> activeBookings =
                      state.activeBookings;
                  return _buildVenueDetail(context, venue, activeBookings);
                } else if (state is VenueDetailOfflineLoaded) {
                  final VenueModel venue = state.venue;
                  final List<BookingModel> activeBookings =
                      state.activeBookings;
                  return _buildVenueDetail(context, venue, activeBookings);
                } else if (state is VenueDetailError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(
                      child: Text(
                          'Da fuk man this is not supposed to show here ...'));
                }
              },
            ),
          ),
          bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 0, reLoad: true,),
        ));
  }

  Widget _buildVenueDetail(BuildContext context, VenueModel venue,
      List<BookingModel> activeBookings) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VenueDetailImageWidget(venue: venue),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  context.push('/create_booking/$venueId');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenAccent,
                  foregroundColor: AppColors.primaryNeutral,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Create a new Booking',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Active Bookings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.lighterPurple,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            activeBookings.isNotEmpty
                ? Column(
                    children: activeBookings
                        .map((booking) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: BookingInfoCard(
                                venue: venue,
                                booking: booking,
                              ),
                            ))
                        .toList(),
                  )
                : const Center(
                    child: Text(
                      'No active bookings available.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
