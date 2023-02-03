import 'package:dartz/dartz.dart';
import 'package:gpt_detector/core/failures/failure.dart';
import 'package:gpt_detector/core/network/network_info.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/api/detector_api.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';

class DetectorRepositoryImpl implements DetectorRepository {
  DetectorRepositoryImpl({required this.detectorApi, required this.networkInfo});

  final DetectorApi detectorApi;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, DetectorEntity>> detect(String inputText) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await detectorApi.detect(inputText);

        return right(response.toDetectorEntity());
      } catch (_) {
        return left(const Failure.networkFailure());
      }
    } else {
      return left(const Failure.noInternetFailure());
    }
  }
}
