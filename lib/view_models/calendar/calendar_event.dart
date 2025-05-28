part of 'calendar_bloc.dart';


abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadCalendarData extends CalendarEvent {
  const LoadCalendarData();

  @override
  List<Object> get props => [];
}

class SelectDate extends CalendarEvent {
  final DateTime selectedDate;

  const SelectDate({required this.selectedDate});

  @override
  List<Object> get props => [selectedDate];
}