part of 'venue_list_bloc.dart';

abstract class VenueListEvent extends Equatable {
  const VenueListEvent();

  @override
  List<Object> get props => [];
}

final class LoadVenueListData extends VenueListEvent {
  const LoadVenueListData();

  @override
  List<Object> get props => [];
}
