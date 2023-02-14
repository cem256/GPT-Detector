import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gpt_detector/app/env/env.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/app/router/app_router.gr.dart';
import 'package:gpt_detector/app/theme/light/light_theme.dart';
import 'package:gpt_detector/core/utils/observer/bloc_observer.dart';
import 'package:gpt_detector/feature/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:gpt_detector/injection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash();
  Bloc.observer = AppBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  configureDependencies();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: Env.fileName);

  runApp(GPTDetector());
}

class GPTDetector extends StatelessWidget {
  GPTDetector({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingCubit>(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, onboarding) {
          final routes = <PageRouteInfo<dynamic>>[];
          onboarding.isCompleted ? routes.add(const DetectRoute()) : routes.add(const OnboardingRoute());

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            // Theme
            theme: getIt<LightTheme>().theme,

            // Localization
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            // Router
            routerDelegate: AutoRouterDelegate.declarative(_appRouter, routes: (_) => routes),
            routeInformationParser: _appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }
}
