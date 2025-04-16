import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/repositories/auth_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_event.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthState()) {
    _startAuthListener();
    _registerHandlers();
  }

  void _startAuthListener() {
    _auth.authStateChanges().listen((User? user) async {
      UserModel? userModel;
      if (user != null) {
        userModel = await authRepository.fetchUser(user.uid);
      }
      add(AuthChangeModelEvent(user, userModel));
    });
  }

  void _registerHandlers() {
    on<AuthChangeModelEvent>((event, emit) {
      emit(AuthState(
        isAuthenticated: event.user != null,
        hasModel: event.userModel != null,
        user: event.user,
        userModel: event.userModel,
      ));
    });
    on<AuthCreateModelEvent>((event, emit) async {
      await authRepository.uploadUser(event.userModel);
      event.completer.complete();

      emit(AuthState(
        isAuthenticated: state.user != null,
        hasModel: true,
        user: state.user,
        userModel: event.userModel,
      ));
    });
    on<AuthRefreshModelEvent>((event, emit) async {
      UserModel? userModel;
      final user = state.user;

      if (user != null) {
        userModel = await authRepository.fetchUser(user.uid);
      }
      emit(AuthState(
        isAuthenticated: state.user != null,
        hasModel: state.userModel != null,
        user: state.user,
        userModel: userModel,
      ));
    });
    on<AuthLogOutEvent>((event, emit) async {
      await _auth.signOut();
      emit(AuthState(
          isAuthenticated: false,
          hasModel: false,
          user: null,
          userModel: null));
    });
  }
}
