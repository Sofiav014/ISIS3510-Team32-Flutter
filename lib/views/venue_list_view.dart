import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart'; // Import BottomNavigationWidget

class VenueListView extends StatelessWidget {
  final String sportId;

  const VenueListView({super.key, required this.sportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue List')),
      body: Center(
        child: Text('Places for sport ID: $sportId'),
      ),
      bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 0), // Add BottomNavigationBar
    );
  }
}