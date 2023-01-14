import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/strings.dart';
import 'core/theme/app_theme.dart';
import 'core/utility/bloc/app_bloc_observer.dart';
import 'core/utility/environment/environment.dart';
import 'feature/detector/presentation/view/detect_view.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  initServices();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: Environment.fileName);

  runApp(const GPTDetector());
}

class GPTDetector extends StatelessWidget {
  const GPTDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: getIt<AppTheme>().appTheme,
      home: const DetectView(),
    );
  }
}
