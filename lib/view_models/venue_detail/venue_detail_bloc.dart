import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/repositories/venue_repository.dart';

part 'venue_detail_event.dart';
part 'venue_detail_state.dart';

class VenueDetailBloc extends Bloc<VenueDetailEvent, VenueDetailState>{
  final VenueRepository venueRepository;

  VenueDetailBloc({required this.venueRepository}): super(VenueDetailInitial()){
    on<LoadVenueDetailData>(_onLoadVenueDetailData);
  }

  Future<void> _onLoadVenueDetailData(
      LoadVenueDetailData event,
      Emitter<VenueDetailState> emit
      )async {
      emit(VenueDetailLoading());
      try{
        final venue = await venueRepository.getVenueById(event.venueId);
        if(venue != null){
          emit(VenueDetailLoaded(venue: venue));
        } else {
          emit(const VenueDetailError(message: 'Venue not found'));
        }
      } catch (e){
        emit(VenueDetailError(message: 'Failed to fetch venue details: $e'));
      }
  }
}