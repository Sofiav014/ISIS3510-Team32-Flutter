import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search View')), //Optional AppBar
      body: const Center(
        child: SizedBox.shrink(), // Or any other empty widget
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}