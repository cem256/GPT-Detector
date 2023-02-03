import 'package:dio/dio.dart';

import 'package:gpt_detector/core/exceptions/exceptions.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';

class DetectorApi {
  DetectorApi({
    required this.dio,
  });
  final Dio dio;

  Future<DetectorModel> detect(String inputText) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/?$inputText',
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
