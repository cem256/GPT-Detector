import 'package:gpt_detector/app/constants/cache_constants.dart';
import 'package:gpt_detector/core/clients/cache/cache_client.dart';
import 'package:injectable/injectable.dart';

abstract interface class SplashLocalDataSource {
  bool? checkIsOnboardingCompleted();
}

@Injectable(as: SplashLocalDataSource)
final class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  SplashLocalDataSourceImpl({required CacheClient cacheClient}) : _cacheClient = cacheClient;

  final CacheClient _cacheClient;

  @override
  bool? checkIsOnboardingCompleted() {
    return _cacheClient.getBool(CacheConstants.isOnboardingCompleted);
  }
}
