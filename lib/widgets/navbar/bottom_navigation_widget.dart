import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex && index != 0) {
      return;
    }
    switch (index) {
      case 0:
        context.push('/search');
        break;
      case 1:
        context.push('/create_booking/11CMLfj0esWbBZjM9eCL');
        break;
      case 2:
        context.push('/home');
        break;
      // case 3:
      //   context.push('/add');
      //   break;
      case 4:
        context.push('/profile');
        break;
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
              selectedIndex == 0
                  ? 'assets/icons/navbar/search-selected.svg'
                  : 'assets/icons/navbar/search.svg',
              color: AppColors.primary,
            ),
            onPressed: () => _onItemTapped(context, 0),
          ),
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 1
                  ? 'assets/icons/navbar/calendar-selected.svg'
                  : 'assets/icons/navbar/calendar.svg',
              color: AppColors.primary,
            ),
            onPressed: () => _onItemTapped(context, 1),
          ),
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 2
                  ? 'assets/icons/navbar/home-selected.svg'
                  : 'assets/icons/navbar/home.svg',
              color: AppColors.primary,
            ),
            onPressed: () => _onItemTapped(context, 2),
          ),
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 3
                  ? 'assets/icons/navbar/add-selected.svg'
                  : 'assets/icons/navbar/add.svg',
              color: AppColors.primary,
            ),
            onPressed: () => _onItemTapped(context, 3),
          ),
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 4
                  ? 'assets/icons/navbar/profile-selected.svg'
                  : 'assets/icons/navbar/profile.svg',
              color: AppColors.primary,
            ),
            onPressed: () => _onItemTapped(context, 4),
          ),
        ],
      ),
    );
  }
}
