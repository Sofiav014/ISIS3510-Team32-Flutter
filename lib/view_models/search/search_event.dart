part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class LoadSearchData extends SearchEvent {
  const LoadSearchData();

  @override
  List<Object> get props => [];
}
