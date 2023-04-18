import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/feature/onboarding/data/data_sources/local/onboarding_local_data_source.dart';
import 'package:gpt_detector/feature/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingLocalDataSource extends Mock implements OnboardingLocalDataSource {}

void main() {
  group('OnboardingRepositoryImpl', () {
    late MockOnboardingLocalDataSource onboardingLocalDataSource;
    late OnboardingRepositoryImpl onboardingRepositoryImpl;

    setUp(() {
      onboardingLocalDataSource = MockOnboardingLocalDataSource();
      onboardingRepositoryImpl = OnboardingRepositoryImpl(onboardingLocalDataSource: onboardingLocalDataSource);
    });

    test('completes onboarding by calling onboardingLocalDataSource.completeOnboarding', () async {
      when(() => onboardingLocalDataSource.completeOnboarding()).thenAnswer((_) async {});

      await onboardingRepositoryImpl.completeOnboarding();

      verify(() => onboardingLocalDataSource.completeOnboarding()).called(1);
    });
  });
}
