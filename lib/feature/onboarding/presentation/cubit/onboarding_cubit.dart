import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'onboarding_state.dart';
part 'onboarding_cubit.freezed.dart';

@injectable
class OnboardingCubit extends HydratedCubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState.initial());

  void completeOnboarding() {
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
