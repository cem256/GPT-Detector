import 'dart:convert';

import 'package:gpt_detector/app/env/env.dart';
import 'package:gpt_detector/app/errors/exceptions.dart';
import 'package:gpt_detector/core/clients/network/network_client.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class DetectorRemoteDataSource {
  Future<DetectorModel> detect(String userInput);
}

@Injectable(as: DetectorRemoteDataSource)
final class DetectorRemoteDataSourceImpl implements DetectorRemoteDataSource {
  DetectorRemoteDataSourceImpl({
    required NetworkClient networkClient,
  }) : _networkClient = networkClient;
  final NetworkClient _networkClient;

  @override
  Future<DetectorModel> detect(String userInput) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
        Env.predict,
        data: {'document': jsonEncode(userInput)},
      );
      final model = response.data;
      if (model == null) {
        throw NetworkException();
      } else {
        return DetectorModel.fromJson(model);
      }
    } catch (_) {
      throw NetworkException();
    }
  }
}
