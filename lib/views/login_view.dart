import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/widgets/login_view/google_sign_in_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Login View');

    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    final isHorizontal = aspectRatio > 1.2;

    final double bottomDistance = isHorizontal ? 60 : 220;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login-background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              "Sporthub",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 70,
            right: 70,
            bottom: bottomDistance,
            child: const GoogleSignInButton(),
          )
        ],
      ),
    );
  }
}
