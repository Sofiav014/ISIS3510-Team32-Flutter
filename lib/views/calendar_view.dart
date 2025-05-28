import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/calendar_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/calendar/calendar_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/widgets/calendar_view/booking_info_card.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'My Bookings');

    final AuthBloc authBloc = context.read<AuthBloc>();

    return BlocProvider(
      create: (context) => CalendarBloc(authBloc: authBloc, connectivityRepository: ConnectivityRepository(),
          calendarRepository: CalendarRepository(), bookingRepository: BookingRepository())..add(const LoadCalendarData()),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          title: Text(
            'My Bookings',
            style: TextStyle(
              color: AppColors.titleText(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.appBarBackground(context),
          automaticallyImplyLeading: false,
          shadowColor: AppColors.text(context),
          elevation: 1,
        ),
        body: BlocListener<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state is CalendarOfflineLoaded) {
              showNoConnectionError(context);
            }
          },
          child: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              if (state is CalendarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CalendarLoaded) {
                List<BookingModel> bookings = state.calendarData;
                return _buildCalendarContent(context, state.selectedDate, bookings);
              } else if (state is CalendarOfflineLoaded) {
                List<BookingModel> bookings = state.calendarData;
                return _buildCalendarContent(context, state.selectedDate, bookings);
              } else if (state is CalendarError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: Text('Loading calendar...'));
              }
            },
          ),
        ),
        bottomNavigationBar:
        const BottomNavigationWidget(selectedIndex: 1, reLoad: false),
      ),
    );
  }

  Widget _buildCalendarTop(BuildContext context, DateTime selectedDate){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('dd').format(selectedDate),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(selectedDate),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text(context),
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(selectedDate),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.text(context),
                ),
              ),
            ],
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/navbar/calendar.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
              width: 30,
              height: 30,
            ),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate, // Start with the currently selected date
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                        surface: AppColors.background(context),
                        onSurface: AppColors.text(context), // Body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (!context.mounted) {
                return;
              }
              if (picked != null && picked != selectedDate) {
                // Dispatch the SelectDate event to the Bloc
                context.read<CalendarBloc>().add(SelectDate(selectedDate: picked));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarBottom(BuildContext context, List<BookingModel> dailyBookings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: dailyBookings.isNotEmpty
          ? Column(
        children: dailyBookings.map((booking) {

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: BookingInfoCard(
              venue: booking.venue,
              booking: booking
            ),
          );
        }).toList(),
      )
          : const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'No bookings for this day',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarContent(BuildContext context, DateTime selectedDate, List<BookingModel> bookings) {
    return Column(
      children: [
        _buildCalendarTop(context, selectedDate),
      const Divider(height: 1, thickness: 1),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Bookings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
        ),
      ),
        _buildCalendarBottom(context, bookings),
      ],
    );
  }
}