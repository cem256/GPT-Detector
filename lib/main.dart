import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gpt_detector/app/l10n/cubit/l10n_cubit.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/app/theme/light/light_theme.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/utils/observer/bloc_observer.dart';
import 'package:gpt_detector/feature/splash/presentation/view/splash_view.dart';
import 'package:gpt_detector/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  // Initialize Flutter Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  // Initialize Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  // Initialize Bloc Observer
  Bloc.observer = AppBlocObserver();
  // Initialize Locator
  await Locator.locateServices();
  // Set Screen Orientation
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(const GPTDetector());
}

class GPTDetector extends StatelessWidget {
  const GPTDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Locator.instance<L10nCubit>(),
      child: BlocBuilder<L10nCubit, L10nState>(
        builder: (context, l10nState) {
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
            locale: l10nState.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              LocaleNamesLocalizationsDelegate(),
            ],

            home: const SplashView(),
          );
        },
      ),
    );
  }
}
