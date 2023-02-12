import 'package:dartz/dartz.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/core/network/network_info.dart';
import 'package:gpt_detector/core/utils/permission_handler/permission_handler.dart';
import 'package:gpt_detector/core/utils/text_recognizer/text_recognizer.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/gallery_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/remote/detector_remote_data_source.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';

class DetectorRepositoryImpl implements DetectorRepository {
  DetectorRepositoryImpl({
    required DetectorRemoteDataSource detectorRemoteDataSource,
    required GalleryLocalDataSource galleryLocalDataSource,
    required PermissionHandlerUtils permissionHandlerUtils,
    required TextRecognizerUtils textRecognizerUtils,
    required NetworkInfo networkInfo,
  })  : _detectorRemoteDataSource = detectorRemoteDataSource,
        _galleryLocalDataSource = galleryLocalDataSource,
        _permissionHandlerUtils = permissionHandlerUtils,
        _textRecognizerUtils = textRecognizerUtils,
        _networkInfo = networkInfo;

  final DetectorRemoteDataSource _detectorRemoteDataSource;

  final GalleryLocalDataSource _galleryLocalDataSource;
  final PermissionHandlerUtils _permissionHandlerUtils;
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
      final filePath = await _galleryLocalDataSource.getImagePath();
      if (filePath == null) {
        // TODO: no file selected or unknown path
        return left(const Failure.networkFailure());
      } else {
        final recognizedText = await _textRecognizerUtils.recognizeText(filePath);
        // TODO: no text detected
        return recognizedText.isEmpty ? left(const Failure.noInternetFailure()) : right(recognizedText);
      }
    } else {
      // TODO: return no permission;
      return left(const Failure.networkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> ocrFromCamera() {
    // TODO: implement ocrFromCamera
    throw UnimplementedError();
  }
}
