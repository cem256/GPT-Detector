import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'env/.env', obfuscate: true)
abstract final class Env {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'BEARER')
  static final String bearer = _Env.bearer;

  @EnviedField(varName: 'PREDICT')
  static final String predict = _Env.predict;
}
