import 'package:gpt_detector/app/constants/cache_constants.dart';
import 'package:gpt_detector/core/clients/cache/cache_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingLocalDataSource {
  OnboardingLocalDataSource({required CacheClient cacheClient}) : _cacheClient = cacheClient;

  final CacheClient _cacheClient;

  Future<void> completeOnboarding() async {
    await _cacheClient.setBool(CacheConstants.isOnboardingCompleted, true);
  }
}
