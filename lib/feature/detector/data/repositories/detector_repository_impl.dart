import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/detector/detector_entity.dart';
import '../../domain/repositories/detector_repository.dart';
import '../data_sources/api/detector_api.dart';
import '../model/detector/detector_model.dart';

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
