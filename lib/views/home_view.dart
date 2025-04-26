import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/view_models/home/home_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/sport_popularity_report_widget.dart';
import 'package:isis3510_team32_flutter/widgets/upcoming_booking_card_widget.dart';
import 'package:isis3510_team32_flutter/widgets/recommended_booking_card_widget.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/models/repositories/home_repository.dart';
import 'package:isis3510_team32_flutter/widgets/venue_popularity_report_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Home View');

    return BlocProvider(
      create: (context) => HomeBloc(
          authBloc: context.read<AuthBloc>(), homeRepository: HomeRepository())
        ..add(const LoadHomeData()),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          title: Text('SportHub',
              style: TextStyle(
                color: AppColors.titleText(context),
                fontWeight: FontWeight.w600,
              )),
          centerTitle: true,
          backgroundColor: AppColors.appBarBackground(context),
          shadowColor: AppColors.text(context),
          elevation: 1,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return _buildHomeContent(state, context);
            } else if (state is HomeError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('Loading...'));
            }
          },
        ),
        bottomNavigationBar: const BottomNavigationWidget(
          selectedIndex: 2,
        ),
      ),
    );
  }

  Widget _buildHomeContent(HomeLoaded state, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildPopularityReport(state.popularityReport),
          _buildUpcomingBookingsSection(state.upcomingBookings),
          _buildBookingsToJoinSection(state.recommendedBookings),
        ],
      ),
    );
  }

  Widget _buildPopularityReport(Map<String, dynamic> popularityReport) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(
                'Popularity Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lighterPurple,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                if (popularityReport['highestRatedVenue'] != null)
                  VenuePopularityReportCardWidget(
                      venue: popularityReport['highestRatedVenue'],
                      title: 'Best Rated Overall',
                      subtitle: popularityReport['highestRatedVenue']
                          .rating
                          .toString()),
                if (popularityReport['mostPlayedSport'] != null)
                  SportPopularityReportCardWidget(
                    sport: popularityReport['mostPlayedSport'],
                    title: 'Most Played by You',
                    sportPlayedCount: popularityReport['mostPlayedSportCount'],
                  ),
                if (popularityReport['mostBookedVenue'] != null)
                  VenuePopularityReportCardWidget(
                    venue: popularityReport['mostBookedVenue'],
                    title: 'Most Booked Overall',
                    subtitle:
                        "${popularityReport['mostBookedVenue'].bookings.length.toString()} bookings",
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookingsSection(List<BookingModel> upcomingBookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Your upcoming bookings',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lighterPurple),
            ),
          ),
        ),
        if (upcomingBookings.isEmpty)
          const Center(
            child: Text(
              'No upcoming bookings',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: upcomingBookings.length,
              itemBuilder: (context, index) {
                return UpcomingBookingCardWidget(
                    booking: upcomingBookings[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBookingsToJoinSection(List<BookingModel> recommendedBookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Bookings you may want to join',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.lighterPurple,
              ),
            ),
          ),
        ),
        if (recommendedBookings.isEmpty)
          const Center(
            child: Text(
              'No recommended bookings',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recommendedBookings.length,
            itemBuilder: (context, index) {
              return RecommendedBookingCardWidget(
                  booking: recommendedBookings[index]);
            },
          ),
      ],
    );
  }
}
