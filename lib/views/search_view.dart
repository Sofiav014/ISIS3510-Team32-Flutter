import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/widgets/search_view_widgets/sport_button_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/search/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/models/data_models/sport_model.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Search View');

    return BlocProvider(
      create: (context) => SearchBloc()..add(const LoadSearchData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search View',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
          centerTitle: true,
          shadowColor: AppColors.primaryLight,
          elevation: 1,
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              return _buildSearchContent(state);
            } else if (state is SearchError) {
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

  Widget _buildSearchContent(SearchLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSportButtons(state.sports),
        ],
      ),
    );
  }

  Widget _buildSportButtons(List<SportModel> sports) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          children: sports.map((sport) {
            return SportButtonWidget(
              text: sport.name,
              imageAsset: sport.logo,
              sport: sport,
              size: 110,
            );
          }).toList(),
        ),
      ),
    );
  }
}
