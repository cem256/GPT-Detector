import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_detector/app/constants/assets.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/extensions/widget_extensions.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_elevated_button.dart';
import 'package:gpt_detector/feature/onboarding/presentation/cubit/onboarding_cubit.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                Assets.appIcon,
                height: context.veryHighValue2x,
                width: double.infinity,
              ),
              Center(
                child: Text(
                  context.l10n.appName,
                  style: context.textTheme.headlineMedium,
                ),
              ),
              Text(
                context.l10n.onboardingInfo1,
                style: context.textTheme.bodyLarge,
              ),
              Text(
                context.l10n.onboardingInfo2,
                style: context.textTheme.bodyLarge,
              ),
              Text(
                context.l10n.onboardingInfo3,
                style: context.textTheme.bodyLarge,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: context.width,
                    height: context.highValue,
                    child: GPTElevatedButton(
                      onPressed: () => context.read<OnboardingCubit>().completeOnboarding(),
                      child: Text(context.l10n.getStarted),
                    ),
                  ),
                ),
              ),
            ]
                .animate(interval: 400.ms)
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
                .spaceBetween(height: context.mediumValue),
          ),
        ),
      ),
    );
  }
}
