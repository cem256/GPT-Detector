import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gpt_detector/core/utility/environment/environment.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkManager {
  NetworkManager() {
    dio = Dio(BaseOptions(baseUrl: Environment.baseUrl));
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }
  }
  late final Dio dio;
}
