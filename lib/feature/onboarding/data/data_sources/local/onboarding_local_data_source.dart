import 'package:gpt_detector/app/constants/cache_constants.dart';
import 'package:gpt_detector/core/clients/cache/cache_client.dart';
import 'package:injectable/injectable.dart';

abstract interface class OnboardingLocalDataSource {
  Future<void> completeOnboarding();
}

@Injectable(as: OnboardingLocalDataSource)
final class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl({required CacheClient cacheClient}) : _cacheClient = cacheClient;

  final CacheClient _cacheClient;
  @override
  Future<void> completeOnboarding() async {
    await _cacheClient.setBool(CacheConstants.isOnboardingCompleted, true);
  }
}
