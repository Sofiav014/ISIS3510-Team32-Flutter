import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isis3510_team32_flutter/core/bloc_observer.dart';
import 'package:isis3510_team32_flutter/core/firebase_options.dart';
import 'package:isis3510_team32_flutter/core/go_router.dart';
import 'package:isis3510_team32_flutter/models/hive/booking_model_hive.dart';
import 'package:isis3510_team32_flutter/models/hive/sport_model_hive.dart';
import 'package:isis3510_team32_flutter/models/hive/venue_model_hive.dart';
import 'package:isis3510_team32_flutter/repositories/auth_repository.dart';
import 'package:isis3510_team32_flutter/repositories/connectivity_repository.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_bloc.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // External dependencies
  await _setupExternalDependencies();

  // Repositories
  _setupRepositories();

  // BLoCs
  _setupBlocs();

  // Router
  _setupRouter();

  //Hive
  await _setupHive();
}

Future<void> _setupExternalDependencies() async {
  // Environment variables
  await dotenv.load(fileName: ".env");

  // Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'sporthub-flutter-client',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Firebase App Check
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.playIntegrity);

  // Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // BLoC observer
  Bloc.observer = AppBlocObserver();
}

void _setupRepositories() {
  // Register AuthRepository as a singleton
  sl.registerSingleton(AuthRepository());
  sl.registerSingleton(ConnectivityRepository());
}

void _setupBlocs() {
  // Register BLoCs
  sl.registerSingleton(AuthBloc(sl<AuthRepository>()));
  sl.registerSingleton(ConnectivityBloc(sl<ConnectivityRepository>()));
  sl.registerSingleton(InitiationBloc());
  sl.registerSingleton(LoadingBloc());
}

void _setupRouter() {
  // Register router
  sl.registerSingleton(setupRouter(sl<AuthBloc>()));
}

Future<void> _setupHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(SportModelHiveAdapter());
  Hive.registerAdapter(VenueModelHiveAdapter());
  Hive.registerAdapter(BookingModelHiveAdapter());
}

