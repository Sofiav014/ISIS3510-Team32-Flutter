import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';
import 'package:isis3510_team32_flutter/view_models/home/home_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/sport_popularity_report_widget.dart';
import 'package:isis3510_team32_flutter/widgets/upcoming_booking_card_widget.dart';
import 'package:isis3510_team32_flutter/widgets/recommended_booking_card_widget.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/repositories/home_repository.dart';
import 'package:isis3510_team32_flutter/widgets/venue_popularity_report_widget.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Home View');

    return BlocProvider(
      create: (context) => HomeBloc(
        authBloc: context.read<AuthBloc>(),
        homeRepository: HomeRepository(),
        connectivityRepository: ConnectivityRepository(),
      )..add(const LoadHomeData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SportHub',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
          centerTitle: true,
          shadowColor: AppColors.primaryLight,
          elevation: 1,
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeOfflineLoaded) {
              showNoConnectionError(context);
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeError) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state is HomeLoaded) {
                return _buildHomeContent(
                  state.upcomingBookings,
                  state.recommendedBookings,
                  state.popularityReport,
                  false,
                );
              } else if (state is HomeOfflineLoaded) {
                return _buildHomeContent(
                  state.cachedUpcomingBookings ?? [],
                  null,
                  state.cachedPopularityReport ?? {},
                  true,
                );
              } else {
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
        bottomNavigationBar: const BottomNavigationWidget(
          selectedIndex: 2,
        ),
      ),
    );
  }

  Widget _buildHomeContent(
    List<BookingModel> upcomingBookings,
    List<BookingModel>? recommendedBookings,
    Map<String, dynamic> popularityReport,
    bool isOffline,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildPopularityReport(popularityReport, isOffline),
          _buildUpcomingBookingsSection(upcomingBookings, isOffline),
          if (recommendedBookings != null)
            _buildBookingsToJoinSection(recommendedBookings, isOffline)
          else
            _buildOfflineRecommendedPlaceholder(isOffline),
        ],
      ),
    );
  }

  Widget _buildPopularityReport(
      Map<String, dynamic> popularityReport, bool isOffline) {
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
                    color: AppColors.primary),
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
                  ),
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
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookingsSection(
      List<BookingModel> upcomingBookings, bool isOffline) {
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
                  color: AppColors.primary),
            ),
          ),
        ),
        if (upcomingBookings.isEmpty)
          Center(
            child: Text(
              isOffline
                  ? 'No upcoming bookings available'
                  : 'No upcoming bookings',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
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

  Widget _buildBookingsToJoinSection(
      List<BookingModel> recommendedBookings, bool isOffline) {
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
                  color: AppColors.primary),
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

  Widget _buildOfflineRecommendedPlaceholder(bool isOffline) {
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
                  color: AppColors.primary),
            ),
          ),
        ),
        Center(
          child: Text(
            isOffline
                ? 'No recommended bookings available while offline.'
                : 'No recommended bookings',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
