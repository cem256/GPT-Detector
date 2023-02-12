import 'package:get_it/get_it.dart';
import 'package:gpt_detector/app/theme/app_theme.dart';
import 'package:gpt_detector/core/network/network_client.dart';
import 'package:gpt_detector/core/network/network_info.dart';
import 'package:gpt_detector/core/utils/image_picker/image_picker.dart';
import 'package:gpt_detector/core/utils/permission_handler/permission_handler.dart';
import 'package:gpt_detector/core/utils/text_recognizer/text_recognizer.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/camera_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/gallery_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/remote/detector_remote_data_source.dart';
import 'package:gpt_detector/feature/detector/data/repositories/detector_repository_impl.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_camera_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_gallery_use_case.dart';
import 'package:gpt_detector/feature/detector/presentation/cubit/detector_cubit.dart';
import 'package:gpt_detector/feature/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Global service locator
final getIt = GetIt.instance;

void initServices() {
  // Cubit
  getIt
    ..registerFactory<OnboardingCubit>(
      OnboardingCubit.new,
    )
    ..registerFactory<DetectorCubit>(
      () => DetectorCubit(
        detectUseCase: getIt(),
        ocrFromGalleryUseCase: getIt(),
        ocrFromCameraUseCase: getIt(),
      ),
    )

    // Use cases
    ..registerLazySingleton<DetectUseCase>(
      () => DetectUseCase(
        detectorRepository: getIt(),
      ),
    )
    ..registerLazySingleton<OCRFromGalleryUseCase>(
      () => OCRFromGalleryUseCase(
        detectorRepository: getIt(),
      ),
    )
    ..registerLazySingleton<OCRFromCameraUseCase>(
      () => OCRFromCameraUseCase(
        detectorRepository: getIt(),
      ),
    )

    // Repository
    ..registerLazySingleton<DetectorRepository>(
      () => DetectorRepositoryImpl(
        detectorRemoteDataSource: getIt(),
        galleryLocalDataSource: getIt(),
        cameraLocalDataSource: getIt(),
        permissionHandlerUtils: getIt(),
        textRecognizerUtils: getIt(),
        networkInfo: getIt(),
      ),
    )

    // Data sources
    ..registerLazySingleton<DetectorRemoteDataSource>(
      () => DetectorRemoteDataSource(networkClient: getIt()),
    )
    ..registerLazySingleton<GalleryLocalDataSource>(
      () => GalleryLocalDataSource(
        imagePicker: getIt(),
      ),
    )
    ..registerLazySingleton<CameraLocalDataSource>(
      () => CameraLocalDataSource(
        imagePicker: getIt(),
      ),
    )

    // Core
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImp(
        connectionChecker: getIt(),
      ),
    )
    ..registerLazySingleton<InternetConnectionChecker>(
      InternetConnectionChecker.new,
    )
    ..registerLazySingleton<NetworkClient>(
      NetworkClient.new,
    )
    ..registerLazySingleton<AppTheme>(
      AppTheme.new,
    )

    // Utils
    ..registerLazySingleton<PermissionHandlerUtils>(
      PermissionHandlerUtilsImpl.new,
    )
    ..registerLazySingleton<ImagePickerUtils>(
      ImagePickerUtilsImpl.new,
    )
    ..registerLazySingleton<TextRecognizerUtils>(
      TextRecognizerUtilsImpl.new,
    );
}
