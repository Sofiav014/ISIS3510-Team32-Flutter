import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isis3510_team32_flutter/core/go_router.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
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

  final authCubit = AuthCubit();

  runApp(
      BlocProvider.value(value: authCubit, child: MyApp(authCubit: authCubit)));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;

  const MyApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    final router = setupRouter(authCubit);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
