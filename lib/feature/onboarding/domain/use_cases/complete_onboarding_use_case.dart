import 'package:gpt_detector/feature/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteOnboardingUseCase {
  CompleteOnboardingUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  final OnboardingRepository _onboardingRepository;

  Future<void> call() async {
    return _onboardingRepository.completeOnboarding();
  }
}
