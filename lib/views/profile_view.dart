import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/bottom_navigation_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Profile View');

    final authBloc = context.read<AuthBloc>();

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
      child: const Column(
        children: [
          Row(
            children: [
              ProfileCardAvatarWidget(),
            ],
          )
        ],
      ),
    );
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
          width: 3,
        ),
      ),
      child: ClipOval(
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/avatar.svg',
            width: 52,
            height: 52,
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
