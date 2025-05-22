part of 'booking_detail_bloc.dart';

abstract class BookingDetailState extends Equatable {
  const BookingDetailState();

  @override
  List<Object> get props => [];
}

class BookingDetailInitial extends BookingDetailState {}

class BookingDetailLoading extends BookingDetailState {}

class BookingDetailLoaded extends BookingDetailState {
  final BookingModel booking;
  final bool error;
  final bool fetching;

  const BookingDetailLoaded(
      {required this.booking, required this.error, required this.fetching});

  @override
  List<Object> get props => [booking];
}

class BookingDetailOfflineLoaded extends BookingDetailState {
  final BookingModel booking;

  const BookingDetailOfflineLoaded({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingDetailError extends BookingDetailState {
  final String message;

  const BookingDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
