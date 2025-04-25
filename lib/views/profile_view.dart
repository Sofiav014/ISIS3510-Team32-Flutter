import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_event.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Profile View');

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Screen')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCardWidget(),
                FavoriteVenuesWidget(),
                LogoutProfileWidget()
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 4),
    );
  }
}

class LogoutProfileWidget extends StatelessWidget {
  const LogoutProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () => authBloc.add(AuthLogOutEvent()),
          child: const Text(
            'Logout',
          )),
    );
  }
}

class FavoriteVenuesWidget extends StatelessWidget {
  const FavoriteVenuesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My favorite venues',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(builder: (bloc, state) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 120,
                child: Row(
                  children: state.userModel != null
                      ? state.userModel!.venuesLiked
                          .map((venue) => Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 20),
                                child: Text(venue.name),
                              ))
                          .toList()
                      : [const Text("Unknown user")],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lighterPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileCardAvatarWidget(),
              ProfileCardTextWidget(),
            ],
          ),
          ProfileCardFavoriteSportsWidget(),
          ProfileCardLightModeSwitchWidget(),
          ProfileCardSettingsButtonWidget()
        ],
      ),
    );
  }
}

class ProfileCardSettingsButtonWidget extends StatelessWidget {
  const ProfileCardSettingsButtonWidget({
    super.key,
  });

  void _showSelectionDialog(BuildContext context) {
    const fontSize = 16.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3F3F3F),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize + 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Edit profile name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Change gender',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Update birth date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Update favorite sports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(color: Colors.green),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        onPressed: () => _showSelectionDialog(context),
        child: const Text('Settings'),
      ),
    );
  }
}

class ProfileCardLightModeSwitchWidget extends StatelessWidget {
  const ProfileCardLightModeSwitchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(
                Icons.sunny,
                size: 24,
                color: AppColors.primary,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    'Light mode',
                  ))
            ],
          ),
          const Spacer(),
          Transform.scale(
            scale: 0.7,
            child: Switch.adaptive(
              activeColor: AppColors.primary,
              activeTrackColor: AppColors.lighterPurple,
              value: true,
              onChanged: (_) {},
            ),
          )
        ],
      ),
    );
  }
}

class ProfileCardFavoriteSportsWidget extends StatelessWidget {
  const ProfileCardFavoriteSportsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 5),
          child: const Text(
            "Favorite sports",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (bloc, state) => Row(
            children: state.userModel != null
                ? state.userModel!.sportsLiked.map(
                    (sport) {
                      return Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Center(
                            child: SvgPicture.asset(
                              initiationSports[sport.id]!.logo,
                              width: 40,
                              height: 40,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList()
                : [],
          ),
        ),
      ],
    );
  }
}

class ProfileCardTextWidget extends StatelessWidget {
  const ProfileCardTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (bloc, state) {
      return Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 230,
              child: Text(
                state.userModel != null
                    ? state.userModel!.name
                    : "Unknown user",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              "Gender: ${state.userModel != null ? state.userModel!.gender : "Unknown"}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
            ),
            Text(
              "Born in ${state.userModel != null ? DateFormat('dd/MM/yyyy').format(state.userModel!.birthDate) : "Unknown"}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
            )
          ],
        ),
      );
    });
  }
}

class ProfileCardAvatarWidget extends StatelessWidget {
  const ProfileCardAvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/avatar.svg',
            width: 64,
            height: 64,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
