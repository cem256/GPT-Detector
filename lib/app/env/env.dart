import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();
  static String get fileName => 'env/.env';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'BASE_URL NOT FOUND';
  static String get bearer => dotenv.env['BEARER'] ?? 'BEARER NOT FOUND';
  static String get predict => dotenv.env['PREDICT'] ?? 'PREDICT NOT FOUND';
}
