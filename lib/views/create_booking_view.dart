import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
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

  const CreateBookingView({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final loadingBloc = context.read<LoadingBloc>();

    FirebaseCrashlytics.instance.setCustomKey('screen', 'Create Booking View');

    return BlocProvider(
      create: (_) => CreateBookingBloc(BookingRepository(), venueId, authBloc),
      child: _CreateBookingContent(loadingBloc: loadingBloc),
    );
  }
}

class _CreateBookingContent extends StatelessWidget {
  final LoadingBloc loadingBloc;

  const _CreateBookingContent({required this.loadingBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateBookingBloc, CreateBookingState>(
          listener: (context, state) {
            if (state.success == true) {
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
          title: const Text(
            'Create Booking',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          shadowColor: AppColors.primaryLight,
          elevation: 1,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DatePickerWidget(),
                const TimeSlotSelectorWidget(),
                const SizedBox(height: 24),
                _CreateBookingButton(loadingBloc: loadingBloc),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationWidget(
          selectedIndex: 1,
        ),
      ),
    );
  }
}

class _CreateBookingButton extends StatelessWidget {
  final LoadingBloc loadingBloc;

  const _CreateBookingButton({required this.loadingBloc});

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
                      }
                    : () {
                        if (connectivityState is ConnectivityOfflineState) {
                          showNoConnectionError(context);
                        } else {
                          showIncompleteFieldsError(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnabled
                      ? AppColors.greenAccent
                      : AppColors.primaryNeutral,
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
