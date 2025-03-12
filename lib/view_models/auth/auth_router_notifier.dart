import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_cubit.dart';

class AuthRouterNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;

  AuthRouterNotifier(this._authCubit) {
    _authCubit.stream.listen((_) {
      notifyListeners();
    });
  }
}
