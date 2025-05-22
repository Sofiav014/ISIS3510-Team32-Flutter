part of 'venue_detail_bloc.dart';

abstract class VenueDetailEvent extends Equatable {
  const VenueDetailEvent();

  @override
  List<Object> get props => [];
}

final class LoadVenueDetailData extends VenueDetailEvent {
  final String venueId;
  final bool? refetch;

  const LoadVenueDetailData({this.refetch, required this.venueId});

  @override
  List<Object> get props => [venueId, refetch ?? false];
}
