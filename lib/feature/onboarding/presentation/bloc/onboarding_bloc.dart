import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';
part 'onboarding_bloc.freezed.dart';

class OnboardingBloc extends HydratedBloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState.initial()) {
    on<_CompleteOnboarding>(_onCompleteOnboarding);
  }

  void _onCompleteOnboarding(_CompleteOnboarding event, Emitter<OnboardingState> emit) {
    emit(const OnboardingState(isCompleted: true));
  }

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) {
    return OnboardingState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(OnboardingState state) {
    return state.toMap();
  }
}
