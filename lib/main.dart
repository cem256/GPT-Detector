import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gpt_detector/core/constants/strings.dart';
import 'package:gpt_detector/core/router/app_router.gr.dart';
import 'package:gpt_detector/core/theme/app_theme.dart';
import 'package:gpt_detector/core/utility/bloc/app_bloc_observer.dart';
import 'package:gpt_detector/core/utility/environment/environment.dart';
import 'package:gpt_detector/feature/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:gpt_detector/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash();
  Bloc.observer = AppBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  initServices();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: Environment.fileName);

  runApp(GPTDetector());
}

class GPTDetector extends StatelessWidget {
  GPTDetector({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingBloc>(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, onboarding) {
          final routes = <PageRouteInfo<dynamic>>[];
          onboarding.isCompleted ? routes.add(const DetectRoute()) : routes.add(const OnboardingRoute());

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            // Theme
            theme: getIt<AppTheme>().theme,

            // Router
            routerDelegate: AutoRouterDelegate.declarative(_appRouter, routes: (_) => routes),
            routeInformationParser: _appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }
}
