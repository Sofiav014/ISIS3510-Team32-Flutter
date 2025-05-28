import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<LoadCalendarData>(_onLoadCalendarData);
    on<SelectDate>(_onSelectDate);
  }

  Future<void> _onLoadCalendarData(
      LoadCalendarData event, Emitter<CalendarState> emit) async {
    emit(CalendarLoading());
    try {
      // Simulate loading, now also initializing with the current date
      await Future.delayed(const Duration(seconds: 1));
      final String fetchedCalendarData = "Calendar data loaded!";
      emit(CalendarLoaded(calendarData: fetchedCalendarData, selectedDate: DateTime.now()));
    } catch (e) {
      emit(CalendarError('Failed to load calendar data: $e'));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<CalendarState> emit) {
    if (state is CalendarLoaded) {
      final currentState = state as CalendarLoaded;
      // It's important to emit a *new* instance of CalendarLoaded
      // even if calendarData is the same, because selectedDate has changed.
      emit(CalendarLoaded( calendarData: currentState.calendarData, selectedDate: event.selectedDate));
    }
    // Also handle if the current state is CalendarOfflineLoaded
    else if (state is CalendarOfflineLoaded) {
      final currentState = state as CalendarOfflineLoaded;
      emit(CalendarOfflineLoaded(calendarData: currentState.calendarData, selectedDate: event.selectedDate));
    }
  }
}