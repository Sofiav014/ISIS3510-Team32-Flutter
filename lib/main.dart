import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/core/service_locator.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/initiation/initiation_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/loading/loading_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_bloc.dart';
import 'package:isis3510_team32_flutter/widgets/loading_overlay_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup all dependencies
  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<InitiationBloc>()),
        BlocProvider(create: (_) => sl<ConnectivityBloc>()),
        BlocProvider(create: (_) => sl<LoadingBloc>()),
        BlocProvider(create: (_) => sl<ThemeBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Navigation',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          primarySwatch: Colors.blue,
        ),
        routerConfig: sl<GoRouter>(),
        builder: (context, child) {
          return Container(
              color: AppColors.background(context),
              child: LoadingOverlayWidget(
                child: child ?? const SizedBox(),
              ));
        },
      ),
    );
  }
}
