import 'package:firebase_auth/firebase_auth.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';

abstract class AuthEvent {}

class AuthCreateModelEvent extends AuthEvent {
  final UserModel userModel;
  AuthCreateModelEvent(this.userModel);
}

class AuthChangeModelEvent extends AuthEvent {
  final User? user;
  final UserModel? userModel;
  AuthChangeModelEvent(this.user, this.userModel);
}

class AuthRefreshModelEvent extends AuthEvent {}

class AuthLogOutEvent extends AuthEvent {}
