import 'package:firebase_auth/firebase_auth.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final bool hasModel;
  final User? user;
  final UserModel? userModel;

  AuthState(
      {this.isAuthenticated = false,
      this.hasModel = false,
      this.user,
      this.userModel});

  @override
  String toString() {
    return "AuthState{\nisAuthenticated: $isAuthenticated,\nhasModel: $hasModel\nuser: $user,\nuserModel: $userModel\n}";
  }
}
