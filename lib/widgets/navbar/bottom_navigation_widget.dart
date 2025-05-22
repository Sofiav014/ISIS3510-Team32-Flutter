import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final bool reLoad;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.reLoad,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex && !reLoad) {
      return;
    }
    switch (index) {
      case 0:
        context.push('/search');
        break;
      // case 1:
      //   context.push('/calendar');
      //   break;
      case 2:
        context.push('/home');
        break;
      case 4:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.background(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 2
                  ? 'assets/icons/navbar/home-selected.svg'
                  : 'assets/icons/navbar/home.svg',
              color: AppColors.lighterPurple,
            ),
            onPressed: () => _onItemTapped(context, 2),
          ),
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 0
                  ? 'assets/icons/navbar/search-selected.svg'
                  : 'assets/icons/navbar/search.svg',
              color: AppColors.lighterPurple,
            ),
            onPressed: () => _onItemTapped(context, 0),
          ),
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 1
                  ? 'assets/icons/navbar/calendar-selected.svg'
                  : 'assets/icons/navbar/calendar.svg',
              color: AppColors.lighterPurple,
            ),
            onPressed: () => _onItemTapped(context, 1),
          ),
          IconButton(
            icon: SvgPicture.asset(
              selectedIndex == 4
                  ? 'assets/icons/navbar/profile-selected.svg'
                  : 'assets/icons/navbar/profile.svg',
              color: AppColors.lighterPurple,
            ),
            onPressed: () => _onItemTapped(context, 4),
          ),
        ],
      ),
    );
  }
}
