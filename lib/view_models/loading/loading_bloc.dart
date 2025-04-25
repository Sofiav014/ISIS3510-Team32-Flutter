import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_event.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(LoadingInitial()) {
    on<ShowLoadingEvent>((event, emit) {
      emit(LoadingInProgress());
    });

    on<HideLoadingEvent>((event, emit) {
      emit(LoadingComplete());
    });
  }
}
