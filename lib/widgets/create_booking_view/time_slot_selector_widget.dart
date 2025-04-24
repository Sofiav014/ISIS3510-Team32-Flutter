import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';

class TimeSlotSelectorWidget extends StatelessWidget {
  const TimeSlotSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateBookingBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Select Time Slot:",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<CreateBookingBloc, CreateBookingState>(
          builder: (context, state) {
            return FutureBuilder<List<String>>(
              future: bloc.bookingRepository.getAvailableTimesID(
                bloc.venueId,
                state.date ?? DateTime.now(),
              ),
              builder: (context, snapshot) {
                final timeSlots = snapshot.data ?? [];

                return SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  child: Row(
                    children: [
                      Wrap(
                        spacing: 8, // Horizontal spacing between items
                        runSpacing: 8, // Vertical spacing between rows
                        children: timeSlots.map((slot) {
                          final isSelected = state.timeSlot == slot;

                          return GestureDetector(
                            onTap: () {
                              bloc.add(CreateBookingTimeSlotEvent(slot));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.lightPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                slot,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.contrast900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
