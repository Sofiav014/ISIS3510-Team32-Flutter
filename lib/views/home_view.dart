import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/core/loading_time_service.dart';
import 'package:isis3510_team32_flutter/widgets/home_view/venue_popularity_report_widget.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/view_models/home/home_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/home_view/sport_popularity_report_widget.dart';
import 'package:isis3510_team32_flutter/widgets/home_view/upcoming_booking_card_widget.dart';
import 'package:isis3510_team32_flutter/widgets/home_view/recommended_booking_card_widget.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/models/repositories/home_repository.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoadingTimeService loadingTimeService = LoadingTimeService();

    loadingTimeService.startTrackingTime();

    FirebaseCrashlytics.instance.setCustomKey('screen', 'Home View');

    return BlocProvider(
      create: (context) => HomeBloc(
        authBloc: context.read<AuthBloc>(),
        homeRepository: HomeRepository(),
        connectivityRepository: ConnectivityRepository(),
      )..add(const LoadHomeData()),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          title: Text('SportHub',
              style: TextStyle(
                color: AppColors.titleText(context),
                fontWeight: FontWeight.w600,
              )),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.appBarBackground(context),
          shadowColor: AppColors.text(context),
          elevation: 1,
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is HomeOfflineLoaded) {
              showNoConnectionError(context);
            } else if (state is HomeLoaded) {
              await loadingTimeService.stopAndRecordTime('Home View');
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
                  color: AppColors.lighterPurple,
                ),
              ),
            ),
          ),
          if (popularityReport['highestRatedVenue'] == null &&
              popularityReport['mostPlayedSport'] == null &&
              popularityReport['mostBookedVenue'] == null)
            Center(
              child: Text(
                isOffline
                    ? 'No upcoming bookings available'
                    : 'No upcoming bookings',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  if (popularityReport['highestRatedVenue'] == null &&
                      popularityReport['mostPlayedSport'] == null &&
                      popularityReport['mostBookedVenue'] == null)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No popularity data available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
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
                      sportPlayedCount:
                          popularityReport['mostPlayedSportCount'],
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
                  color: AppColors.lighterPurple),
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
                  color: AppColors.lighterPurple),
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
