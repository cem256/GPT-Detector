import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gpt_detector/core/utils/logger/logger_utils.dart';
import 'package:gpt_detector/core/utils/observer/bloc_observer.dart';
import 'package:gpt_detector/firebase_options.dart';
import 'package:gpt_detector/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> bootstrap({required FutureOr<Widget> Function() builder}) async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  // Initialize Flutter Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  // Register error handlers. For more info, see:
  // https://docs.flutter.dev/testing/errors
  // Pass all uncaught Flutter framework exceptions to Crashlytics
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
    LoggerUtils.instance.logFatalError(details.exceptionAsString(), details.stack);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    LoggerUtils.instance.logFatalError(error.toString(), stack);
    return true;
  };

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

  runApp(await builder());
}
