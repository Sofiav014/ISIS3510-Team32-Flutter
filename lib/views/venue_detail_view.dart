import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/venue_repository.dart';
import 'package:isis3510_team32_flutter/view_models/venue_detail/venue_detail_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/widgets/venue_detail_widgets/booking_info_card.dart';
import 'package:isis3510_team32_flutter/widgets/venue_detail_widgets/venue_detail_image_widget.dart';

class VenueDetailView extends StatelessWidget {
  final String sportId;
  final String venueId;

  const VenueDetailView({super.key, required this.sportId, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            VenueDetailBloc(venueRepository: VenueRepository())
            ..add(LoadVenueDetailData(venueId: venueId)),
        child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () {
                      context.go('/venue_list/$sportId');
                    },
                  ),
                  title: const Text('Venue Detail',
                      style: TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.w600)),
                  centerTitle: true,
                  shadowColor: AppColors.primaryLight,
                  elevation: 1,
                ),
                body: BlocBuilder<VenueDetailBloc, VenueDetailState>(
                  builder: (context, state) {
                    if (state is VenueDetailLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is VenueDetailLoaded) {
                      final VenueModel venue = state.venue;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            VenueDetailImageWidget(venue: venue),
                            const SizedBox(height: 16), // Add space below the image
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Botón para la doña Sofía');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.awfulGreen,
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
                                    color: AppColors.primary
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Center(
                              child: Text(
                                'Active Bookings',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: venue.bookings.map((booking) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: BookingInfoCard(venue: venue, booking: booking),
                                  )).toList(),
                                ),
                            )
                          ],
                        ),
                      );
                    } else if (state is VenueDetailError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const Center(child: Text('Loading Venue Details...'));
                    }
                  },
                ),
                bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 0),
              )
    );
  }
}