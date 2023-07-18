import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/feature/splash/data/data_sources/local/splash_local_data_source.dart';
import 'package:gpt_detector/feature/splash/data/repositories/splash_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockSplashLocalDataSource extends Mock implements SplashLocalDataSource {}

void main() {
  group('SplashRepositoryImpl', () {
    late MockSplashLocalDataSource splashLocalDataSource;
    late SplashRepositoryImpl splashRepositoryImpl;

    setUp(() {
      splashLocalDataSource = MockSplashLocalDataSource();
      splashRepositoryImpl = SplashRepositoryImpl(splashLocalDataSource: splashLocalDataSource);
    });

    test('returns false when splashLocalDataSource.checkIsOnboardingCompleted returns false', () {
      when(() => splashLocalDataSource.checkIsOnboardingCompleted()).thenReturn(false);

      final result = splashRepositoryImpl.checkIsOnboardingCompleted();

      expect(result, false);
      verify(() => splashLocalDataSource.checkIsOnboardingCompleted()).called(1);
    });

    test('returns true when splashLocalDataSource.checkIsOnboardingCompleted returns true', () {
      when(() => splashLocalDataSource.checkIsOnboardingCompleted()).thenReturn(true);

      final result = splashRepositoryImpl.checkIsOnboardingCompleted();

      expect(result, true);
      verify(() => splashLocalDataSource.checkIsOnboardingCompleted()).called(1);
    });

    test('returns null when splashLocalDataSource.checkIsOnboardingCompleted returns null', () {
      when(() => splashLocalDataSource.checkIsOnboardingCompleted()).thenReturn(null);

      final result = splashRepositoryImpl.checkIsOnboardingCompleted();

      expect(result, null);
      verify(() => splashLocalDataSource.checkIsOnboardingCompleted()).called(1);
    });
  });
}
