import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/repositories/booking_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';
import 'package:isis3510_team32_flutter/widgets/create_booking_view/date_picker_widget.dart';
import 'package:isis3510_team32_flutter/widgets/create_booking_view/time_slot_selector_widget.dart';

class CreateBookingView extends StatelessWidget {
  final String venueId;

  const CreateBookingView({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

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
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              DatePickerWidget(),
              SizedBox(height: 24),
              TimeSlotSelectorWidget(),
              // const SizedBox(height: 24),
              // _MaxUsersSelector(),
              // const Spacer(),
              // _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaxUsersSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateBookingBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Number of Players:",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<CreateBookingBloc, CreateBookingState>(
          builder: (context, state) {
            return DropdownButton<int>(
              value: state.maxUsers,
              hint: const Text("Select number"),
              items: List.generate(20, (index) => index + 1)
                  .map((num) => DropdownMenuItem<int>(
                        value: num,
                        child: Text(num.toString()),
                      ))
                  .toList(),
              onChanged: (num) {
                if (num != null) {
                  bloc.add(CreateBookingMaxUsersEvent(num));
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateBookingBloc>();
    return BlocBuilder<CreateBookingBloc, CreateBookingState>(
      builder: (context, state) {
        final isEnabled = state.date != null &&
            state.timeSlot != null &&
            state.maxUsers != null;

        return ElevatedButton(
          onPressed: isEnabled
              ? () {
                  bloc.add(CreateBookingSubmitEvent());
                  Navigator.pop(context);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          ),
          child: const Text(
            "Create Booking",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
