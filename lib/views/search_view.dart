import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/view_models/search_view_model.dart';
import 'package:isis3510_team32_flutter/models/sport.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search View')),
        body: Consumer<SearchViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: viewModel.sports.length,
              itemBuilder: (context, index) {
                Sport sport = viewModel.sports[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(sport.imageUrl),
                    title: Text(sport.name),
                    onTap: () {
                      context.go('/venue_list/${sport.id}');
                    },
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: const BottomNavigationWidget(),
      ),
    );
  }
}