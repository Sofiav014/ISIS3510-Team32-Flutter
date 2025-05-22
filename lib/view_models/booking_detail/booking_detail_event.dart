part of 'booking_detail_bloc.dart';

abstract class BookingDetailEvent extends Equatable {
  const BookingDetailEvent();

  @override
  List<Object> get props => [];
}

final class LoadBookingDetailData extends BookingDetailEvent {
  final BookingModel booking;
  final bool error;
  final bool fetching;

  const LoadBookingDetailData(
      {required this.booking, required this.error, required this.fetching});

  @override
  List<Object> get props => [booking, error, fetching];
}
