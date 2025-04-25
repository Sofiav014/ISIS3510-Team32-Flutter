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
  final Map<String, dynamic> popularityReport;

  const HomeLoaded(
      {required this.upcomingBookings,
      required this.recommendedBookings,
      required this.popularityReport});

  @override
  List<Object> get props =>
      [upcomingBookings, recommendedBookings, popularityReport];
}

class HomeError extends HomeState {
  final String error;
  const HomeError(this.error);

  @override
  List<Object> get props => [error];
}

class HomeOfflineLoaded extends HomeState {
  final List<BookingModel>? cachedUpcomingBookings;
  final Map<String, dynamic>? cachedPopularityReport;

  const HomeOfflineLoaded({
    this.cachedUpcomingBookings,
    this.cachedPopularityReport,
  });

  @override
  List<Object> get props => [
        cachedUpcomingBookings ?? [],
        cachedPopularityReport ?? {},
      ];
}
