import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_event.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_event.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    final loadingBloc = context.read<LoadingBloc>();

    loadingBloc.add(ShowLoadingEvent());

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is already signed in, return their credentials
      loadingBloc.add(HideLoadingEvent());
      return FirebaseAuth.instance.currentUser as UserCredential?;
    }

    // Begin interactive sign-in process
    final googleSignIn = GoogleSignIn();

    // Sign out any cached GoogleSignIn user to force "Choose account" screen
    await googleSignIn.signOut();
    GoogleSignInAccount? gUser;

    bool timedOut = false;

    try {
      gUser = await googleSignIn.signIn().timeout(
            const Duration(seconds: 20),
          );
    } on TimeoutException {
      timedOut = true;
    }

    if (gUser == null || timedOut) {
      loadingBloc.add(HideLoadingEvent());
      if (timedOut) {
        // ignore: use_build_context_synchronously
        showFailedToAuthenticateError(context);
      }
      return null;
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    loadingBloc.add(HideLoadingEvent());

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    final connectivityBloc = context.read<ConnectivityBloc>();

    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
      return SignInButton(
        Buttons.google,
        text: "Sign in with Google",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () async {
          if (state is ConnectivityOnlineState) {
            signInWithGoogle(context);
          } else {
            showFailedToAuthenticateError(context);
            connectivityBloc.add(ConnectivityRequestedFetchEvent());
          }
        },
      );
    });
  }
}
