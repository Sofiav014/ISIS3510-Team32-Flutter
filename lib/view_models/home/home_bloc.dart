import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';
import 'package:isis3510_team32_flutter/models/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthBloc authBloc;
  final HomeRepository homeRepository;
  final ConnectivityRepository connectivityRepository;
  late final StreamSubscription<bool> _connectivitySubscription;

  HomeBloc({
    required this.authBloc,
    required this.homeRepository,
    required this.connectivityRepository,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);

    // Escuchar cambios de conectividad
    _connectivitySubscription =
        connectivityRepository.connectivityChanges.listen((isConnected) {
      if (isConnected) {
        add(const LoadHomeData());
      }
    });
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final AuthState authState = authBloc.state;
      final UserModel? user = authState.userModel;

      if (user == null) {
        emit(const HomeError('User not found or not authenticated.'));
        return;
      }

      final isOnline = await connectivityRepository.hasInternet;

      if (isOnline) {
        try {
          final upcomingBookings = homeRepository.getUpcomingBookings(user);

          final recommendedBookings =
              await homeRepository.getRecommendedBookings(user);

          final popularityReport = await homeRepository.popularityReport(user);

          await homeRepository.cacheHomeData(
            userId: user.id,
            upcoming: upcomingBookings,
            report: popularityReport,
          );

          emit(HomeLoaded(
            upcomingBookings: upcomingBookings,
            recommendedBookings: recommendedBookings,
            popularityReport: popularityReport,
          ));
        } catch (e) {
          final cachedUpcomingBookings =
              await homeRepository.getCachedUpcomingBookings(user.id);
          final cachedPopularityReport =
              await homeRepository.getCachedPopularityReport(user.id);

          emit(HomeOfflineLoaded(
            cachedUpcomingBookings: cachedUpcomingBookings,
            cachedPopularityReport: cachedPopularityReport,
          ));
        }
      } else {
        final cachedUpcomingBookings =
            await homeRepository.getCachedUpcomingBookings(user.id);
        final cachedPopularityReport =
            await homeRepository.getCachedPopularityReport(user.id);

        emit(HomeOfflineLoaded(
          cachedUpcomingBookings: cachedUpcomingBookings,
          cachedPopularityReport: cachedPopularityReport,
        ));
      }
    } catch (e) {
      emit(HomeError('Unexpected error while loading home data: $e'));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription
        .cancel(); // Cancelar la suscripción al cerrar el Bloc
    return super.close();
  }
}
