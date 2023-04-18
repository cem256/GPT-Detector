import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/feature/splash/domain/repositories/splash_repository.dart';
import 'package:gpt_detector/feature/splash/domain/use_cases/check_is_onboarding_completed_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSplashRepository extends Mock implements SplashRepository {}

void main() {
  group('CheckIsOnboardingCompletedUseCase', () {
    late MockSplashRepository splashRepository;
    late CheckIsOnboardingCompletedUseCase checkIsOnboardingCompletedUseCase;

    setUp(() {
      splashRepository = MockSplashRepository();
      checkIsOnboardingCompletedUseCase = CheckIsOnboardingCompletedUseCase(splashRepository: splashRepository);
    });

    test('returns false when splashRepository.checkIsOnboardingCompleted returns false', () {
      when(() => splashRepository.checkIsOnboardingCompleted()).thenReturn(false);

      final result = checkIsOnboardingCompletedUseCase.call();

      expect(result, false);
      verify(() => splashRepository.checkIsOnboardingCompleted()).called(1);
    });

    test('returns true when splashRepository.checkIsOnboardingCompleted returns true', () {
      when(() => splashRepository.checkIsOnboardingCompleted()).thenReturn(true);

      final result = checkIsOnboardingCompletedUseCase.call();

      expect(result, true);
      verify(() => splashRepository.checkIsOnboardingCompleted()).called(1);
    });

    test('returns null when splashRepository.checkIsOnboardingCompleted returns null', () {
      when(() => splashRepository.checkIsOnboardingCompleted()).thenReturn(null);

      final result = checkIsOnboardingCompletedUseCase.call();

      expect(result, null);
      verify(() => splashRepository.checkIsOnboardingCompleted()).called(1);
    });
  });
}
