import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/feature/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:gpt_detector/feature/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  group('CompleteOnboardingUseCase', () {
    late MockOnboardingRepository onboardingRepository;
    late CompleteOnboardingUseCase completeOnboardingUseCase;

    setUp(() {
      onboardingRepository = MockOnboardingRepository();
      completeOnboardingUseCase = CompleteOnboardingUseCase(onboardingRepository: onboardingRepository);
    });

    test('completes onboarding by calling onboardingRepository.completeOnboarding', () async {
      when(() => onboardingRepository.completeOnboarding()).thenAnswer((_) async {});

      await completeOnboardingUseCase.call();

      verify(() => onboardingRepository.completeOnboarding()).called(1);
    });
  });
}
