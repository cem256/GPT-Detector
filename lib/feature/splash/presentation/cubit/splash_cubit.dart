import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/app/base/cubit/base_cubit.dart';

import 'package:gpt_detector/feature/splash/domain/use_cases/check_is_onboarding_completed_use_case.dart';
import 'package:injectable/injectable.dart';

part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

@injectable
class SplashCubit extends BaseCubit<SplashState> {
  SplashCubit({required CheckIsOnboardingCompletedUseCase checkIsOnboardingCompletedUseCase})
      : _checkIsOnboardingCompletedUseCase = checkIsOnboardingCompletedUseCase,
        super(SplashState.initial());

  final CheckIsOnboardingCompletedUseCase _checkIsOnboardingCompletedUseCase;

  void checkIsOnboardingCompleted() {
    final result = _checkIsOnboardingCompletedUseCase.call();
    if (result == null || result == false) {
      emit(state.copyWith(isOnboardingCompleted: false));
    } else {
      emit(state.copyWith(isOnboardingCompleted: true));
    }
  }
}
