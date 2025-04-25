import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';

class CreateBookingButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateBookingButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookingBloc, CreateBookingState>(
      builder: (context, state) {
        // Check if all required fields are selected
        final isEnabled = state.date != null &&
            state.timeSlot != null &&
            state.maxUsers != null &&
            state.maxUsers! > 0;
        print("Is button enabled: $isEnabled");

        return Center(
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null, // Disable if not enabled
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled
                  ? AppColors.greenAccent
                  : AppColors.greenAccent
                      .withAlpha(128), // Change color if disabled
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24), // Rounded corners
              ),
            ),
            child: const Text(
              'Create Reservation',
              style: TextStyle(
                color: AppColors.primary, // Text color
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
