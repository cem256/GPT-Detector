import 'package:get_it/get_it.dart';
import 'package:gpt_detector/feature/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/network_info.dart';
import 'core/network/network_manager.dart';
import 'core/theme/app_theme.dart';
import 'feature/detector/data/data_sources/api/detector_api.dart';
import 'feature/detector/data/repositories/detector_repository_impl.dart';
import 'feature/detector/domain/repositories/detector_repository.dart';
import 'feature/detector/domain/use_cases/detect_use_case.dart';
import 'feature/detector/presentation/bloc/detector_bloc.dart';

// Global service locator
final getIt = GetIt.instance;

void initServices() {
  // Feature - Detector
  // Bloc
  getIt.registerFactory(
    () => OnboardingBloc(),
  );
  getIt.registerFactory(
    () => DetectorBloc(
      detectUseCase: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => DetectUseCase(
      detectorRepository: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<DetectorRepository>(
    () => DetectorRepositoryImpl(
      detectorApi: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton(
    () => DetectorApi(dio: getIt<NetworkManager>().dio),
  );

  // Core
  getIt.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(
      connectionChecker: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => NetworkManager(),
  );
  getIt.registerLazySingleton(
    () => AppTheme(),
  );
}
