// filepath: c:\Users\sofia\OneDrive - Universidad de los andes\Documentos\UNIANDES\8 Semestre (2025-1)\Moviles\App Flutter\lib\widgets\create_booking_view\date_picker_widget.dart
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
            return CalendarDatePicker(
              initialDate: state.date ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              onDateChanged: (selectedDate) {
                bloc.add(CreateBookingDateEvent(selectedDate));
              },
            );
          },
        ),
      ],
    );
  }
}
