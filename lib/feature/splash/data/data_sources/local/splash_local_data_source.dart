import 'package:gpt_detector/app/constants/cache_constants.dart';
import 'package:gpt_detector/core/clients/cache/cache_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class SplashLocalDataSource {
  SplashLocalDataSource({required CacheClient cacheClient}) : _cacheClient = cacheClient;

  final CacheClient _cacheClient;

  bool? checkIsOnboardingCompleted() {
    return _cacheClient.getBool(CacheConstants.isOnboardingCompleted);
  }
}
