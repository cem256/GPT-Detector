import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/feature/splash/domain/use_cases/check_is_onboarding_completed_use_case.dart';
import 'package:gpt_detector/feature/splash/presentation/cubit/splash_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckIsOnboardingCompletedUseCase extends Mock implements CheckIsOnboardingCompletedUseCase {}

void main() {
  group('SplashCubit', () {
    late MockCheckIsOnboardingCompletedUseCase checkIsOnboardingCompletedUseCase;
    late SplashCubit splashCubit;

    setUp(() {
      checkIsOnboardingCompletedUseCase = MockCheckIsOnboardingCompletedUseCase();
      splashCubit = SplashCubit(checkIsOnboardingCompletedUseCase: checkIsOnboardingCompletedUseCase);
    });

    tearDown(() {
      splashCubit.close();
    });

    test('initial state is SplashState.initial()', () {
      expect(splashCubit.state, SplashState.initial());
    });

    blocTest<SplashCubit, SplashState>(
      'emits [isOnboardingCompleted: false] when checkIsOnboardingCompletedUseCase returns false',
      build: () {
        when(() => checkIsOnboardingCompletedUseCase.call()).thenReturn(false);
        return splashCubit;
      },
      act: (cubit) => cubit.checkIsOnboardingCompleted(),
      expect: () => [const SplashState(isOnboardingCompleted: false)],
    );

    blocTest<SplashCubit, SplashState>(
      'emits [isOnboardingCompleted: true] when checkIsOnboardingCompletedUseCase returns true',
      build: () {
        when(() => checkIsOnboardingCompletedUseCase.call()).thenReturn(true);
        return splashCubit;
      },
      act: (cubit) => cubit.checkIsOnboardingCompleted(),
      expect: () => [const SplashState(isOnboardingCompleted: true)],
    );
  });
}
