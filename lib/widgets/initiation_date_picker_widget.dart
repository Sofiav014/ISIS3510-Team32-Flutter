import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_event.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_state.dart';

class InitiationDatePicker extends StatelessWidget {
  const InitiationDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final initiationBloc = context.read<InitiationBloc>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<InitiationBloc, InitiationState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () => _selectDate(context, initiationBloc),
                child: Text(
                  initiationBloc.state.birthDate != null
                      ? DateFormat.yMd().format(initiationBloc.state.birthDate!)
                      : 'Select a date',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future _selectDate(
          BuildContext context, InitiationBloc initiationBloc) async =>
      showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 365 * 14)),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now().subtract(const Duration(days: 365 * 14)),
      ).then((DateTime? selected) {
        if (selected != null && selected != initiationBloc.state.birthDate) {
          initiationBloc.add(InitiationAgeEvent(selected));
        }
      });
}
