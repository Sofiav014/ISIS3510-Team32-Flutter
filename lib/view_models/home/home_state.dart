part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<BookingModel> upcomingBookings;
  final List<BookingModel> recommendedBookings;

  const HomeLoaded({required this.upcomingBookings, required this.recommendedBookings});

  @override
  List<Object> get props => [upcomingBookings, recommendedBookings];
}

class HomeError extends HomeState {
  final String error;
  const HomeError(this.error);

  @override
  List<Object> get props => [error];
}
