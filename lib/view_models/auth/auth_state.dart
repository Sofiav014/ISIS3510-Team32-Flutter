import 'package:firebase_auth/firebase_auth.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final UserModel? userModel;

  AuthState({this.isAuthenticated = false, this.user, this.userModel});

  @override
  String toString() {
    return "AuthState{\nisAuthenticated: $isAuthenticated,\nuser: $user,\nuserModel: $userModel\n}";
  }
}
