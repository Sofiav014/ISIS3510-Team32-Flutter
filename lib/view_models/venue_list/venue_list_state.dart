part of 'venue_list_bloc.dart';

abstract class VenueListState extends Equatable {
  const VenueListState();

  @override
  List<Object> get props => [];
}

class VenueListInitial extends VenueListState {}

class VenueListLoading extends VenueListState {}

class VenueListLoaded extends VenueListState {
  final List<VenueModel> venues;

  const VenueListLoaded({required this.venues});

  @override
  List<Object> get props => [venues];
}

class VenueListError extends VenueListState {
  final String error;

  const VenueListError(this.error);

  @override
  List<Object> get props => [error];
}
