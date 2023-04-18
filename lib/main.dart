import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gpt_detector/app/env/env.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/app/theme/light/light_theme.dart';
import 'package:gpt_detector/core/utils/observer/bloc_observer.dart';
import 'package:gpt_detector/feature/splash/presentation/view/splash_view.dart';
import 'package:gpt_detector/injection.dart';

Future<void> main() async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  Bloc.observer = AppBlocObserver();

  configureDependencies();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: Env.fileName);
  runApp(const GPTDetector());
}

class GPTDetector extends StatelessWidget {
  const GPTDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Theme
      theme: getIt<LightTheme>().theme,

      // Localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: const SplashView(),
    );
  }
}
