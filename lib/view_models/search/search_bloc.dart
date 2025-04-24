import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/models/data_models/sport_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<LoadSearchData>(_onLoadSearchData);
  }

  Future<void> _onLoadSearchData(
      LoadSearchData event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final sports = initiationSports.values.toList();
      emit(SearchLoaded(sports: sports));
    } catch (e) {
      emit(SearchError('Failed to load search data: $e'));
    }
  }
}
