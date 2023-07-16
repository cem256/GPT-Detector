import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/app/theme/light/light_theme.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/utils/observer/bloc_observer.dart';
import 'package:gpt_detector/feature/splash/presentation/view/splash_view.dart';
import 'package:gpt_detector/locator.dart';

Future<void> main() async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  Bloc.observer = AppBlocObserver();

  await Locator.locateServices();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const GPTDetector());
}

class GPTDetector extends StatelessWidget {
  const GPTDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      builder: (context, child) => MediaQuery(
        // Disables font scaling and bold text
        data: context.mediaQuery.copyWith(textScaleFactor: 1, boldText: false),
        // Dismisses the keyboard globally
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        ),
      ),

      // Theme
      theme: Locator.instance<LightTheme>().theme,

      // Localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: const SplashView(),
    );
  }
}
