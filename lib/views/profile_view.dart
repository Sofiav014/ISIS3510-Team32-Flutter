import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [const ProfileCardWidget(), Container()],
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 4),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              ProfileCardAvatarWidget(),
              ProfileCardTextWidget(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
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
                            return Image(image: NetworkImage(sport.logo));
                          },
                        ).toList()
                      : [],
                ),
              ),
            ],
          )
        ],
      ),
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
