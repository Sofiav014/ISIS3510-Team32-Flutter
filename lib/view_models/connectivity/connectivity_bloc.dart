import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_event.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';

import '../../repositories/connectivity_repository.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityRepository repository;
  StreamSubscription<bool>? _subscription;

  ConnectivityBloc(this.repository) : super(ConnectivityInitialState()) {
    _registerHandlers();
    _setupSubscription();
  }

  void _setupSubscription() {
    _subscription = repository.connectivityChanges.listen((online) {
      add(ConnectivityChangedEvent(online));
    });
  }

  void _registerHandlers() {
    on<ConnectivityChangedEvent>((event, emit) async {
      emit(event.online
          ? ConnectivityOnlineState()
          : ConnectivityOfflineState());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

