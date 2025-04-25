import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/widgets/create_booking_view/create_booking_button_widget.dart';
import 'package:isis3510_team32_flutter/widgets/create_booking_view/date_picker_widget.dart';
import 'package:isis3510_team32_flutter/widgets/create_booking_view/time_slot_selector_widget.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';

class CreateBookingView extends StatelessWidget {
  final String venueId;

  const CreateBookingView({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    FirebaseCrashlytics.instance.setCustomKey('screen', 'Create Booking View');

    return BlocProvider(
      create: (_) => CreateBookingBloc(BookingRepository(), venueId, authBloc),
      child: const _CreateBookingContent(),
    );
  }
}

class _CreateBookingContent extends StatelessWidget {
  const _CreateBookingContent();

  @override
  Widget build(BuildContext context) {
    final createBookingBloc = context.read<CreateBookingBloc>();

    return Scaffold(
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
              const SizedBox(height: 24), // Add spacing before the button
              CreateBookingButtonWidget(
                onPressed: () {
                  print("Button pressed!");
                  createBookingBloc.add(CreateBookingSubmitEvent());
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(
        selectedIndex: 1,
      ),
    );
  }
}
