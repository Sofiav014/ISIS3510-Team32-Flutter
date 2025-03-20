import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/view_models/search_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/widgets/search_view_widgets/sport_button_widget.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search View',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
          centerTitle: true,
          shadowColor: AppColors.primaryLight,
          elevation: 1,
        ),
        body: Consumer<SearchViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              padding: const EdgeInsets.all(20.0),
              children: viewModel.sports.map((sport) {
                return SportButtonWidget(
                  text: sport.name,
                  imageAsset: sport.logo,
                  sport: sport,
                  size: 110,
                );
              }).toList(),
            );
          },
        ),
        bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 0),
      ),
    );
  }
}