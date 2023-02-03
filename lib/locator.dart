import 'package:get_it/get_it.dart';
import 'package:gpt_detector/core/network/network_info.dart';
import 'package:gpt_detector/core/network/network_manager.dart';
import 'package:gpt_detector/core/theme/app_theme.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/api/detector_api.dart';
import 'package:gpt_detector/feature/detector/data/repositories/detector_repository_impl.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
import 'package:gpt_detector/feature/detector/presentation/bloc/detector_bloc.dart';
import 'package:gpt_detector/feature/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Global service locator
final getIt = GetIt.instance;

void initServices() {
  // Feature - Detector
  // Bloc
  getIt
    ..registerFactory(
      OnboardingBloc.new,
    )
    ..registerFactory(
      () => DetectorBloc(
        detectUseCase: getIt(),
      ),
    )

    // Use cases
    ..registerLazySingleton(
      () => DetectUseCase(
        detectorRepository: getIt(),
      ),
    )

    // Repository
    ..registerLazySingleton<DetectorRepository>(
      () => DetectorRepositoryImpl(
        detectorApi: getIt(),
        networkInfo: getIt(),
      ),
    )

    // Data sources
    ..registerLazySingleton(
      () => DetectorApi(dio: getIt<NetworkManager>().dio),
    )

    // Core
    ..registerLazySingleton(
      InternetConnectionChecker.new,
    )
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImp(
        connectionChecker: getIt(),
      ),
    )
    ..registerLazySingleton(
      NetworkManager.new,
    )
    ..registerLazySingleton(
      AppTheme.new,
    );
}
