part of 'booking_detail_bloc.dart';

abstract class BookingDetailEvent extends Equatable {
  const BookingDetailEvent();

  @override
  List<Object> get props => [];
}

final class LoadBookingDetailData extends BookingDetailEvent {
  final BookingModel booking;

  const LoadBookingDetailData({required this.booking});

  @override
  List<Object> get props => [booking];
}

final class UpdateBooking extends BookingDetailEvent {
  final BookingModel booking;

  const UpdateBooking({required this.booking});

  @override
  List<Object> get props => [booking];
}
