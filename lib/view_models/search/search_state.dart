part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SportModel> sports;

  const SearchLoaded({required this.sports});

  @override
  List<Object> get props => [sports];
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);

  @override
  List<Object> get props => [error];
}
