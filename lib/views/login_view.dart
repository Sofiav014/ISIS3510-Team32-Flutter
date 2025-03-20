import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/widgets/google_sign_in_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(
            child: Text(
              "Sporthub",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 70,
            right: 70,
            bottom: 220,
            child: GoogleSignInButton(),
          )
        ],
      ),
    );
  }
}
