import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/core/bloc_observer.dart';
import 'package:isis3510_team32_flutter/core/go_router.dart';
import 'package:isis3510_team32_flutter/repositories/auth_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';
import 'package:provider/provider.dart';

import 'core/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'sporthub-flutter-client',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.playIntegrity);

  Bloc.observer = AppBlocObserver();

  final authRepository = AuthRepository();
  final authBloc = AuthBloc(authRepository);
  final router = setupRouter(authBloc);

  runApp(MyApp(
    authRepository: authRepository,
    authBloc: authBloc,
    router: router,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final AuthBloc authBloc;
  final GoRouter router;

  const MyApp(
      {required this.authRepository,
      required this.authBloc,
      required this.router,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => authBloc),
          BlocProvider(create: (context) => InitiationBloc()),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Navigation',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
