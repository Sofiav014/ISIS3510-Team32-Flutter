import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/core/booking_view_service.dart';
import 'package:isis3510_team32_flutter/core/screen_time_service.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_event.dart';
import 'package:isis3510_team32_flutter/widgets/create_booking_view/date_picker_widget.dart';
import 'package:isis3510_team32_flutter/widgets/create_booking_view/time_slot_selector_widget.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';

class CreateBookingView extends StatelessWidget {
  final String venueId;
  final ScreenTimeService screenTimeService;

  const CreateBookingView({
    super.key,
    required this.venueId,
    required this.screenTimeService,
  });
  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final loadingBloc = context.read<LoadingBloc>();

    FirebaseCrashlytics.instance.setCustomKey('screen', 'Create Booking View');

    screenTimeService.startTrackingTime();

    return BlocProvider(
      create: (_) => CreateBookingBloc(BookingRepository(), venueId, authBloc),
      child: _CreateBookingContent(
          loadingBloc: loadingBloc, screenTimeService: screenTimeService),
    );
  }
}

class _CreateBookingContent extends StatelessWidget {
  final LoadingBloc loadingBloc;
  final ScreenTimeService screenTimeService;

  const _CreateBookingContent(
      {required this.loadingBloc, required this.screenTimeService});

  @override
  Widget build(BuildContext context) {
    final BookingViewService bookingViewService = BookingViewService();

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateBookingBloc, CreateBookingState>(
          listener: (context, state) {
            if (state.success == true) {
              bookingViewService.recordView('Create Booking View');
              loadingBloc.add(HideLoadingEvent());
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                  title: const Text('Booking Created'),
                  content:
                      const Text('Your booking has been successfully created!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ).then((_) {
                context.pop();
              });
            } else if (state.success == false) {
              loadingBloc.add(HideLoadingEvent());
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                  title: const Text('Booking Failed'),
                  content: const Text(
                      'Failed to create the booking. Please try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ).then((_) {
                context.pop();
              });
            }
          },
        ),
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, connectivityState) {
            if (connectivityState is ConnectivityOfflineState) {
              showNoConnectionError(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Booking',
            style: TextStyle(
              color: AppColors.titleText(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.appBarBackground(context),
          shadowColor: AppColors.text(context),
          elevation: 1,
        ),
        backgroundColor: AppColors.background(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DatePickerWidget(),
                const TimeSlotSelectorWidget(),
                const SizedBox(height: 24),
                _CreateBookingButton(
                    loadingBloc: loadingBloc,
                    screenTimeService: screenTimeService),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationWidget(
          selectedIndex: 1, reLoad: true,
        ),
      ),
    );
  }
}

class _CreateBookingButton extends StatelessWidget {
  final LoadingBloc loadingBloc;
  final ScreenTimeService screenTimeService;

  const _CreateBookingButton(
      {required this.loadingBloc, required this.screenTimeService});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivityState) {
        return BlocBuilder<CreateBookingBloc, CreateBookingState>(
          builder: (context, state) {
            final createBookingBloc = context.read<CreateBookingBloc>();

            final isEnabled = connectivityState is ConnectivityOnlineState &&
                state.date != null &&
                state.timeSlot != null &&
                state.maxUsers != null;

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isEnabled
                    ? () async {
                        loadingBloc.add(ShowLoadingEvent());
                        createBookingBloc.add(CreateBookingSubmitEvent());

                        await screenTimeService
                            .stopAndRecordTime('Create Booking View');
                      }
                    : () {
                        if (state.date == null ||
                            state.timeSlot == null ||
                            state.maxUsers == null) {
                          showIncompleteFieldsError(context);
                        } else if (connectivityState
                            is ConnectivityOfflineState) {
                          showNoConnectionError(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isEnabled ? Colors.greenAccent : AppColors.primaryNeutral,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Create Booking',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
