import 'package:dartz/dartz.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/core/network/network_info.dart';
import 'package:gpt_detector/core/utils/image_cropper/image_cropper.dart';
import 'package:gpt_detector/core/utils/permission_handler/permission_handler.dart';
import 'package:gpt_detector/core/utils/text_recognizer/text_recognizer.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/camera_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/gallery_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/remote/detector_remote_data_source.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DetectorRepository)
class DetectorRepositoryImpl implements DetectorRepository {
  DetectorRepositoryImpl({
    required DetectorRemoteDataSource detectorRemoteDataSource,
    required GalleryLocalDataSource galleryLocalDataSource,
    required CameraLocalDataSource cameraLocalDataSource,
    required PermissionHandlerUtils permissionHandlerUtils,
    required ImageCropperUtils imageCropperUtils,
    required TextRecognizerUtils textRecognizerUtils,
    required NetworkInfo networkInfo,
  })  : _detectorRemoteDataSource = detectorRemoteDataSource,
        _galleryLocalDataSource = galleryLocalDataSource,
        _cameraLocalDataSource = cameraLocalDataSource,
        _permissionHandlerUtils = permissionHandlerUtils,
        _imageCropperUtils = imageCropperUtils,
        _textRecognizerUtils = textRecognizerUtils,
        _networkInfo = networkInfo;

  final DetectorRemoteDataSource _detectorRemoteDataSource;
  final GalleryLocalDataSource _galleryLocalDataSource;
  final CameraLocalDataSource _cameraLocalDataSource;
  final PermissionHandlerUtils _permissionHandlerUtils;
  final ImageCropperUtils _imageCropperUtils;
  final TextRecognizerUtils _textRecognizerUtils;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, DetectorEntity>> detect(String userInput) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _detectorRemoteDataSource.detect(userInput);

        return right(response.toDetectorEntity());
      } catch (_) {
        return left(const Failure.networkFailure());
      }
    } else {
      return left(const Failure.noInternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> ocrFromGallery() async {
    final hasPermission = await _permissionHandlerUtils.hasGalleryPermission();

    if (hasPermission) {
      final filePath = await _galleryLocalDataSource.selectFromGallery();
      if (filePath == null) {
        // No file selected or unknown path
        return left(const Failure.ocrFailure());
      } else {
        final croppedFilePath = await _imageCropperUtils.cropPhoto(filePath: filePath);
        if (croppedFilePath == null) {
          // File not cropped  or unknown path
          return left(const Failure.ocrFailure());
        } else {
          final recognizedText = await _textRecognizerUtils.recognizeTextFormFilePath(filePath: croppedFilePath);
          // No text detected
          return recognizedText.isEmpty ? left(const Failure.ocrFailure()) : right(recognizedText);
        }
      }
    } else {
      //  No permission
      return left(const Failure.noPermission());
    }
  }

  @override
  Future<Either<Failure, String>> ocrFromCamera() async {
    final hasPermission = await _permissionHandlerUtils.hasCameraPermission();

    if (hasPermission) {
      final filePath = await _cameraLocalDataSource.takePhoto();
      if (filePath == null) {
        // No photo taken or unknown path
        return left(const Failure.ocrFailure());
      } else {
        final croppedFilePath = await _imageCropperUtils.cropPhoto(filePath: filePath);
        if (croppedFilePath == null) {
          // File not cropped  or unknown path
          return left(const Failure.ocrFailure());
        } else {
          final recognizedText = await _textRecognizerUtils.recognizeTextFormFilePath(filePath: croppedFilePath);
          // No text detected
          return recognizedText.isEmpty ? left(const Failure.ocrFailure()) : right(recognizedText);
        }
      }
    } else {
      // No permission
      return left(const Failure.noPermission());
    }
  }
}
