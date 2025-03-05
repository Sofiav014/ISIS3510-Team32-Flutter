import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
//import 'package:go_router/go_router.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primaryNeutral,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.search_outlined, color: AppColors.primary),
            //onPressed: () => context.go('/search'),
            onPressed: () {
              // Search logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined,
                color: AppColors.primary),
            //onPressed: () => context.go('/my-bookings'),
            onPressed: () {
              // Bookings logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined, color: AppColors.primary),
            //onPressed: () => context.go('/home'),
            onPressed: () {
              // Home logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: AppColors.primary),
            //onPressed: () => context.go('/add-booking'),
            onPressed: () {
              // Add logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.primary),
            //onPressed: () => context.go('/profile'),
            onPressed: () {
              // Profile logic
            },
          ),
        ],
      ),
    );
  }
}
