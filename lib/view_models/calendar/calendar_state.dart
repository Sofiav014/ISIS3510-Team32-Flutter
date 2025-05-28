part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final String calendarData;
  final DateTime selectedDate;

  const CalendarLoaded({required this.calendarData, required this.selectedDate});

  @override
  List<Object> get props => [calendarData, selectedDate];
}

class CalendarOfflineLoaded extends CalendarState {
  final String calendarData;
  final DateTime selectedDate;

  const CalendarOfflineLoaded({required this.calendarData, required this.selectedDate});

  @override
  List<Object> get props => [calendarData, selectedDate];
}

class CalendarError extends CalendarState {
  final String error;

  const CalendarError(this.error);

  @override
  List<Object> get props => [error];
}