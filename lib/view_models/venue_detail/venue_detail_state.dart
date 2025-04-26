part of 'venue_detail_bloc.dart';

abstract class VenueDetailState extends Equatable {
  const VenueDetailState();

  @override
  List<Object> get props => [];
}

class VenueDetailInitial extends VenueDetailState {}

class VenueDetailLoading extends VenueDetailState {}

class VenueDetailLoaded extends VenueDetailState {
  final VenueModel venue;

  const VenueDetailLoaded({required this.venue});

  @override
  List<Object> get props => [venue];
}

class VenueDetailOfflineLoaded extends VenueDetailState {
  final VenueModel venue;

  const VenueDetailOfflineLoaded({required this.venue});

  @override
  List<Object> get props => [venue];
}

class VenueDetailError extends VenueDetailState {
  final String message;

  const VenueDetailError({required this.message});

  @override
  List<Object> get props => [message];
}