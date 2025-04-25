import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    return BlocListener<CreateBookingBloc, CreateBookingState>(
      listener: (context, state) {
        if (state.success == true) {
          // Show success popup and navigate to home view
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Booking Created'),
              content:
                  const Text('Your booking has been successfully created!'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.push('/home'); // Navigate to home view
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state.success == false) {
          // Show failure popup
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Booking Failed'),
              content:
                  const Text('Failed to create the booking. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                    context.pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
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
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DatePickerWidget(),
                TimeSlotSelectorWidget(),
                SizedBox(height: 24),
                _CreateBookingButton(),
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
  const _CreateBookingButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookingBloc, CreateBookingState>(
      builder: (context, state) {
        final createBookingBloc = context.read<CreateBookingBloc>();

        final isEnabled = state.date != null &&
            state.timeSlot != null &&
            state.maxUsers != null;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () async {
                    createBookingBloc.add(CreateBookingSubmitEvent());
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenAccent,
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
  }
}
