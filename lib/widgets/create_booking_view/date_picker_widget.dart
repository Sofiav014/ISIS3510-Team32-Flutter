import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_event.dart';
import 'package:isis3510_team32_flutter/view_models/create_booking/create_booking_state.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateBookingBloc>();
    final now = DateTime.now();

    // Si ya son más de las 10:00 p.m., la primera fecha seleccionable será mañana
    final todayCutoff = DateTime(now.year, now.month, now.day, 22);
    final firstAvailableDate = now.isAfter(todayCutoff)
        ? DateTime(now.year, now.month, now.day + 1)
        : DateTime(now.year, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Choose a Date:",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<CreateBookingBloc, CreateBookingState>(
          builder: (context, state) {
            final initialDate = state.date ?? firstAvailableDate;

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              child: CalendarDatePicker(
                initialDate: initialDate.isBefore(firstAvailableDate)
                    ? firstAvailableDate
                    : initialDate,
                firstDate: firstAvailableDate,
                lastDate: now.add(const Duration(days: 60)),
                onDateChanged: (selectedDate) {
                  bloc.add(CreateBookingDateEvent(selectedDate));
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
