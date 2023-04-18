part of 'splash_cubit.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState({
    bool? isOnboardingCompleted,
  }) = _SplashState;

  factory SplashState.initial() => const SplashState();
}
