import 'package:dartz/dartz.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/core/clients/image_cropper/imge_cropper_client.dart';
import 'package:gpt_detector/core/clients/network_info/network_info_client.dart';
import 'package:gpt_detector/core/clients/permission_client/permission_client.dart';
import 'package:gpt_detector/core/clients/text_recognizer/text_recognizer_client.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/camera_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/gallery_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/remote/detector_remote_data_source.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DetectorRepository)
class DetectorRepositoryImpl implements DetectorRepository {
  DetectorRepositoryImpl({
    required DetectorRemoteDataSource detectorRemoteDataSource,
    required GalleryLocalDataSource galleryLocalDataSource,
    required CameraLocalDataSource cameraLocalDataSource,
    required PermissionClient permissionClient,
    required ImageCropperClient imageCropperClient,
    required TextRecognizerClient textRecognizerClient,
    required NetworkInfoClient networkInfoClient,
  })  : _detectorRemoteDataSource = detectorRemoteDataSource,
        _galleryLocalDataSource = galleryLocalDataSource,
        _cameraLocalDataSource = cameraLocalDataSource,
        _permissionClient = permissionClient,
        _imageCropperClient = imageCropperClient,
        _textRecognizerClient = textRecognizerClient,
        _networkInfoClient = networkInfoClient;

  final DetectorRemoteDataSource _detectorRemoteDataSource;
  final GalleryLocalDataSource _galleryLocalDataSource;
  final CameraLocalDataSource _cameraLocalDataSource;
  final PermissionClient _permissionClient;
  final ImageCropperClient _imageCropperClient;
  final TextRecognizerClient _textRecognizerClient;
  final NetworkInfoClient _networkInfoClient;

  @override
  Future<Either<Failure, DetectorEntity>> detect(String userInput) async {
    if (await _networkInfoClient.isConnected) {
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
    final hasPermission = await _permissionClient.hasGalleryPermission();

    if (hasPermission) {
      final filePath = await _galleryLocalDataSource.selectFromGallery();
      if (filePath == null) {
        // No file selected or unknown path
        return left(const Failure.ocrFailure());
      } else {
        final croppedFilePath = await _imageCropperClient.cropPhoto(filePath: filePath);
        if (croppedFilePath == null) {
          // File not cropped  or unknown path
          return left(const Failure.ocrFailure());
        } else {
          final recognizedText = await _textRecognizerClient.recognizeTextFormFilePath(filePath: croppedFilePath);
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
    final hasPermission = await _permissionClient.hasCameraPermission();

    if (hasPermission) {
      final filePath = await _cameraLocalDataSource.takePhoto();
      if (filePath == null) {
        // No photo taken or unknown path
        return left(const Failure.ocrFailure());
      } else {
        final croppedFilePath = await _imageCropperClient.cropPhoto(filePath: filePath);
        if (croppedFilePath == null) {
          // File not cropped  or unknown path
          return left(const Failure.ocrFailure());
        } else {
          final recognizedText = await _textRecognizerClient.recognizeTextFormFilePath(filePath: croppedFilePath);
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
