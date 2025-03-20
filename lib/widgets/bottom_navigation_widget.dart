import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
       case 0:
         context.go('/search');
      //   break;
      // case 1:
      //   context.go('/calendar');
      //   break;
      case 2:
        context.go('/home');
        break;
      // case 3:
      //   context.go('/add');
      //   break;
      // case 4:
      //   context.go('/profile');
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primaryNeutral,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              _selectedIndex == 0
                  ? 'assets/icons/navbar/search-selected.svg'
                  : 'assets/icons/navbar/search.svg',
              color: AppColors.primary,
            ),
            onPressed: () {
              _onItemTapped(0);
              // Search logic
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              _selectedIndex == 1
                  ? 'assets/icons/navbar/calendar-selected.svg'
                  : 'assets/icons/navbar/calendar.svg',
              color: AppColors.primary,
            ),
            onPressed: () {
              _onItemTapped(1);
              // Bookings logic
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              _selectedIndex == 2
                  ? 'assets/icons/navbar/home-selected.svg'
                  : 'assets/icons/navbar/home.svg',
              color: AppColors.primary,
            ),
            onPressed: () {
              _onItemTapped(2);
              // Home logic
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              _selectedIndex == 3
                  ? 'assets/icons/navbar/add-selected.svg'
                  : 'assets/icons/navbar/add.svg',
              color: AppColors.primary,
            ),
            onPressed: () {
              _onItemTapped(3);
              // Add logic
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              _selectedIndex == 4
                  ? 'assets/icons/navbar/profile-selected.svg'
                  : 'assets/icons/navbar/profile.svg',
              color: AppColors.primary,
            ),
            onPressed: () {
              _onItemTapped(4);
              // Profile logic
            },
          ),
        ],
      ),
    );
  }
}
