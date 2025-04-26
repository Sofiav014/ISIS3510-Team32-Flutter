import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/widgets/search_view/venue_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/venue_list/venue_list_bloc.dart';
import 'package:isis3510_team32_flutter/models/repositories/venue_repository.dart';

class VenueListView extends StatelessWidget {
  final String sportName;

  const VenueListView({super.key, required this.sportName});

  String _formatSportName(String name) {
    return name.toLowerCase().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final formattedSportName = _formatSportName(sportName);

    FirebaseCrashlytics.instance
        .setCustomKey('screen', '$formattedSportName Venues View');

    return BlocProvider(
      create: (context) => VenueListBloc(
          sportName: sportName,
          venueRepository: VenueRepository(),
          connectivityRepository: ConnectivityRepository())
        ..add(const LoadVenueListData()),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar:  AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () {
              context.push('/search');
            },
          ),
          title: Text('$formattedSportName Venues',
              style: const TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
          centerTitle: true,
          shadowColor: AppColors.text(context),
          elevation: 1,
          backgroundColor: AppColors.appBarBackground(context),
        ),
        body: BlocListener<VenueListBloc, VenueListState>(
            listener: (context, state) {
          if (state is VenueListOfflineLoaded) showNoConnectionError(context);
        }, child: BlocBuilder<VenueListBloc, VenueListState>(
          builder: (context, state) {
            if (state is VenueListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VenueListLoaded) {
              return _buildVenueListContent(state.venues);
            } else if (state is VenueListOfflineLoaded) {
              return _buildVenueListContent(state.venues);
            } else if (state is VenueListError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(
                  child:
                      Text('Da fuk man this is not supposed to show here ...'));
            }
          },
        )),
        bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 0),
      ),
    );
  }

  Widget _buildVenueListContent(List<VenueModel> venues) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildVenueList(venues),
        ],
      ),
    );
  }

  Widget _buildVenueList(List<VenueModel> venues) {
    if (venues.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No venues found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: venues.map((venue) => VenueListWidget(venue: venue)).toList(),
    );
  }
}
