import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthState()) {
    _auth.authStateChanges().listen((User? user) {
      emit(AuthState(
        isAuthenticated: user != null,
        user: user,
      ));
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
