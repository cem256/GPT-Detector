import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  Environment._();
  static String get fileName => 'env/.env';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'NOT FOUND';
}
