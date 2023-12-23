import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/feature/onboarding/domain/use_cases/complete_onboarding_use_case.dart';

import 'package:injectable/injectable.dart';

part 'onboarding_state.dart';
part 'onboarding_cubit.freezed.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required CompleteOnboardingUseCase completeOnboardingUseCase})
      : _completeOnboardingUseCase = completeOnboardingUseCase,
        super(const OnboardingState());

  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  Future<void> completeOnboarding() async {
    await _completeOnboardingUseCase.call();
  }
}
