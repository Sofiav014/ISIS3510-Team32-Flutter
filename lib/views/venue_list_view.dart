import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/widgets/search_view_widgets/venue_list_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/venue_list/venue_list_bloc.dart';
import 'package:isis3510_team32_flutter/repositories/venue_repository.dart';

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
          sportName: sportName, venueRepository: VenueRepository())
        ..add(const LoadVenueListData()),
      child: Scaffold(
        appBar: AppBar(
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
          shadowColor: AppColors.primaryLight,
          elevation: 1,
        ),
        body: BlocBuilder<VenueListBloc, VenueListState>(
          builder: (context, state) {
            if (state is VenueListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VenueListLoaded) {
              return _buildVenueListContent(state);
            } else if (state is VenueListError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('Loading...'));
            }
          },
        ),
        bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 0),
      ),
    );
  }

  Widget _buildVenueListContent(VenueListLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildVenueList(state.venues),
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
