import 'package:dio/dio.dart';

import '../../../../../core/exceptions/exceptions.dart';
import '../../model/detector/detector_model.dart';

class DetectorApi {
  final Dio dio;

  DetectorApi({
    required this.dio,
  });

  Future<DetectorModel> detect(String inputText) async {
    try {
      final response = await dio.get(
        '/?$inputText',
      );
      dynamic model = response.data;
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
