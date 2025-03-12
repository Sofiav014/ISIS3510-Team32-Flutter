import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';
import 'package:isis3510_team32_flutter/repositories/auth_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthState()) {
    _auth.authStateChanges().listen((User? user) async {
      UserModel? userModel;
      if (user != null) {
        userModel = await _authRepository.fetchUser(user.uid);
      }
      emit(AuthState(
        isAuthenticated: user != null,
        user: user,
        userModel: userModel,
      ));
    });
  }

  Future<void> uploadUser(UserModel userModel) async {
    await _authRepository.uploadUser(userModel);
  }

  Future<void> refreshModelData() async {
    UserModel? userModel;
    final user = state.user;

    if (user != null) {
      userModel = await _authRepository.fetchUser(user.uid);
    }
    emit(AuthState(
      isAuthenticated: state.user != null,
      user: state.user,
      userModel: userModel,
    ));
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
