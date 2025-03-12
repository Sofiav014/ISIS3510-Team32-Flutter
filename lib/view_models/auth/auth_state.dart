import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool isAuthenticated;
  final User? user;

  AuthState({this.isAuthenticated = false, this.user});
}
