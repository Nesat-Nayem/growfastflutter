import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/bloc/app_bloc/app_bloc.dart';
import 'package:grow_first/core/theme/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/di/app_injections.dart';
import 'app/router/app_router.dart';
import 'core/config/app_config.dart';
import 'core/app_store/app_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (with error handling)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will continue without Firebase features');
  }

  // Choose environment (could be from --dart-define, here hardcoded for development)
  const env = 'dev';

  late AppConfig config;
  try {
    config = await ConfigLoader.load(env);
  } catch (e, stack) {
    debugPrint('Failed to load AppConfig for $env: $e\n$stack');
    return; // stop app from running if config fails
  }

  // Initialize dependency injection with loaded config
  await configureDependencies(config);
  
  // Load user data from secure storage
  await sl<AppStore>().load();

  runApp(GrowFirstApp(config: config));
}

class GrowFirstApp extends StatefulWidget {
  final AppConfig config;
  const GrowFirstApp({super.key, required this.config});

  @override
  State<GrowFirstApp> createState() => _GrowFirstAppState();
}

class _GrowFirstAppState extends State<GrowFirstApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final appBloc = sl<AppBloc>()..add(AppStarted());
    _router = AppRouter.buildRouter(appBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<AppBloc>())],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            title: 'Grow First',
            theme: ApplicationTheme.getAppThemeData(),
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
