import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';

class AuthRouterNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;
  late final StreamSubscription _subscription;

  AuthRouterNotifier(this._authBloc) {
    _subscription = _authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
