import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/app/theme/cubit/theme_cubit.dart';
import 'package:gpt_detector/app/theme/dark/dark_theme.dart';
import 'package:gpt_detector/app/theme/light/light_theme.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/feature/splash/presentation/view/splash_view.dart';
import 'package:gpt_detector/locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Locator.instance<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            builder: (context, child) => MediaQuery(
              // Disables font scaling and bold text
              data: context.mediaQuery.copyWith(textScaler: TextScaler.noScaling, boldText: false),
              // Dismisses the keyboard globally
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: child,
              ),
            ),

            // Theme
            themeMode: themeState.themeMode,
            theme: Locator.instance<LightTheme>().theme,
            darkTheme: Locator.instance<DarkTheme>().theme,

            // Localization
            locale: AppLocalizations.supportedLocales.first,
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
