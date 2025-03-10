import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';
import 'package:isis3510_team32_flutter/view_models/home/home_bloc.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/widgets/upcoming_booking_card_widget.dart';
import 'package:isis3510_team32_flutter/widgets/recommended_booking_card_widget.dart';

class HomeView extends StatelessWidget {
  final String userId;

  const HomeView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SportHub',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
          centerTitle: true,
          shadowColor: AppColors.primaryLight,
          elevation: 1,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return _buildHomeContent(state);
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

  Widget _buildHomeContent(HomeLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUpcomingBookingsSection(state.upcomingBookings),
          _buildBookingsToJoinSection(state.recommendedBookings),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookingsSection(List<BookingModel> upcomingBookings) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
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
      ),
    );
  }

  Widget _buildBookingsToJoinSection(List<BookingModel> recommendedBookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(16.0),
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
