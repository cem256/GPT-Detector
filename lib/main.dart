import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gpt_detector/core/theme/app_theme.dart';
import 'package:gpt_detector/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/strings.dart';
import 'core/utility/bloc/app_bloc_observer.dart';
import 'core/utility/environment/environment.dart';
import 'feature/detector/presentation/view/detect_view.dart';
import 'feature/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'locator.dart';

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

  runApp(const GPTDetector());
}

class GPTDetector extends StatelessWidget {
  const GPTDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingBloc>(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: getIt<AppTheme>().theme,
            home: state.isCompleted ? const DetectView() : const OnboardingView(),
          );
        },
      ),
    );
  }
}
