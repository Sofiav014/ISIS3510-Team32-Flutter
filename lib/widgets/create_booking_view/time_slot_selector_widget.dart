import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';

class TimeSlotSelectorWidget extends StatelessWidget {
  const TimeSlotSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateBookingBloc>();

    return BlocBuilder<CreateBookingBloc, CreateBookingState>(
      builder: (context, state) {
        return FutureBuilder<List<String>>(
          future: bloc.bookingRepository.getAvailableTimesID(
            bloc.venueId,
            state.date ?? DateTime.now(),
          ),
          builder: (context, snapshot) {
            final timeSlots = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.8, // more compact ratio
                        physics: const NeverScrollableScrollPhysics(),
                        children: timeSlots.map((slot) {
                          final isSelected = state.timeSlot == slot;

                          return GestureDetector(
                            onTap: () {
                              bloc.add(CreateBookingTimeSlotEvent(slot));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.contrast900
                                    : AppColors.primaryNeutral,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                slot,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/people.svg",
                            height: 20,
                            color: AppColors.contrast900,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Number of Players",
                            style: TextStyle(
                              color: AppColors.contrast900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNeutral,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: state.maxUsers,
                            hint: const Text("Select number"),
                            isExpanded: true,
                            iconSize: 20,
                            style: const TextStyle(fontSize: 14),
                            items: List.generate(12, (index) => index + 1)
                                .map((num) => DropdownMenuItem<int>(
                                      value: num,
                                      child: Text(
                                        num.toString(),
                                        style: const TextStyle(
                                          color: AppColors
                                              .primary, // color visible sobre blanco
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (num) {
                              if (num != null) {
                                bloc.add(CreateBookingMaxUsersEvent(num));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
