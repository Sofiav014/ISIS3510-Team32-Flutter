import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/venue_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';

part 'venue_detail_event.dart';
part 'venue_detail_state.dart';

class VenueDetailBloc extends Bloc<VenueDetailEvent, VenueDetailState> {
  final VenueRepository venueRepository;
  final ConnectivityRepository connectivityRepository;
  final String venueId;
  late final StreamSubscription<bool> _connectivitySubscription;

  final AuthBloc authBloc;

  VenueDetailBloc(
      {required this.venueRepository,
      required this.connectivityRepository,
      required this.venueId,
      required this.authBloc})
      : super(VenueDetailInitial()) {
    on<LoadVenueDetailData>(_onLoadVenueDetailData);

    _connectivitySubscription =
        connectivityRepository.connectivityChanges.listen((isConnected) {
      if (isConnected) add(LoadVenueDetailData(venueId: venueId));
    });
  }

  Future<void> _onLoadVenueDetailData(
      LoadVenueDetailData event, Emitter<VenueDetailState> emit) async {
    emit(VenueDetailLoading());
    try {
      final isOnline = await connectivityRepository.hasInternet;
      if (isOnline) {
        final venue =
            await venueRepository.getVenueById(venueId, event.refetch != null);

        if (venue != null) {
          final activeBookings = venueRepository.getActiveBookingsByVenue(
              venue, authBloc.state.userModel!.id);
          emit(VenueDetailLoaded(venue: venue, activeBookings: activeBookings));
        } else {
          emit(const VenueDetailError(message: 'Venue not found'));
        }
      } else {
        final venue = await venueRepository.getCachedVenueById(venueId);
        if (venue != null) {
          emit(
              VenueDetailOfflineLoaded(venue: venue, activeBookings: const []));
        } else {
          emit(const VenueDetailError(message: 'Venue not found'));
        }
      }
    } catch (e) {
      emit(VenueDetailError(message: 'Failed to fetch venue details: $e'));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
