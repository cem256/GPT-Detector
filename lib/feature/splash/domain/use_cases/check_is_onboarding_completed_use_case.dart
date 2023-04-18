import 'package:gpt_detector/feature/splash/domain/repositories/splash_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckIsOnboardingCompletedUseCase {
  CheckIsOnboardingCompletedUseCase({
    required SplashRepository splashRepository,
  }) : _splashRepository = splashRepository;

  final SplashRepository _splashRepository;

  bool? call() {
    return _splashRepository.checkIsOnboardingCompleted();
  }
}
