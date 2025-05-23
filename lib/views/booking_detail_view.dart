import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/view_models/booking_detail/booking_detail_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/booking_detail_view/booking_info_widget.dart';
import 'package:isis3510_team32_flutter/widgets/booking_detail_view/venue_detail_image_widget.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';

class BookingDetailView extends StatelessWidget {
  final BookingModel booking;
  final int selectedIndex;

  const BookingDetailView(
      {super.key, required this.booking, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Booking Detail View');

    return BlocProvider(
        create: (context) => BookingDetailBloc(
            bookingRepository: BookingRepository(),
            connectivityRepository: ConnectivityRepository(),
            booking: booking)
          ..add(LoadBookingDetailData(booking: booking)),
        child: Scaffold(
          backgroundColor: AppColors.background(context),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.titleText(context)),
              onPressed: () {
                context.pop();
              },
            ),
            title: Text('Booking Detail',
                style: TextStyle(
                  color: AppColors.titleText(context),
                  fontWeight: FontWeight.w600,
                )),
            centerTitle: true,
            backgroundColor: AppColors.appBarBackground(context),
            shadowColor: AppColors.text(context),
            elevation: 1,
          ),
          body: BlocListener<BookingDetailBloc, BookingDetailState>(
            listener: (context, state) {
              if (state is BookingDetailOfflineLoaded) {
                showNoConnectionError(context);
              }
            },
            child: BlocBuilder<BookingDetailBloc, BookingDetailState>(
              builder: (context, state) {
                if (state is BookingDetailLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingDetailLoaded) {
                  return _buildBookingDetail(
                      context, state.booking, state.fetching, state.error);
                } else if (state is BookingDetailOfflineLoaded) {
                  return _buildBookingDetailOfline(context, state.booking);
                } else if (state is BookingDetailError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(
                      child: Text(
                          'Da fuk man this is not supposed to show here ...'));
                }
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationWidget(
              selectedIndex: selectedIndex, reLoad: true),
        ));
  }

  Widget _buildBookingDetail(
      BuildContext context, BookingModel booking, bool fetching, bool error) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VenueDetailImageWidget(venue: booking.venue),
            const SizedBox(height: 16),
            BookingInfo(booking: booking)
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetailOfline(BuildContext context, BookingModel booking) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VenueDetailImageWidget(venue: booking.venue),
            const SizedBox(height: 16),
            BookingInfo(booking: booking)
          ],
        ),
      ),
    );
  }
}
