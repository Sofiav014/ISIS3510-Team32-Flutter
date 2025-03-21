import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/venue_list_view_model.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'package:isis3510_team32_flutter/widgets/search_view_widgets/venue_list_widget.dart';

class VenueListView extends StatelessWidget {
  final String sportName;

  const VenueListView({super.key, required this.sportName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VenueViewModel(sportName),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Venue List',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
          centerTitle: true,
          shadowColor: AppColors.primaryLight,
          elevation: 1,
        ),
        body: Consumer<VenueViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: viewModel.venues.length,
              itemBuilder: (context, index) {
                VenueModel venue = viewModel.venues[index];
                return VenueListWidget(venue: venue); // Use VenueListWidget
              },
            );
          },
        ),
        bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 0),
      ),
    );
  }
}