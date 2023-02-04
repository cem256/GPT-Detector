import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_detector/core/constants/assets.dart';
import 'package:gpt_detector/core/constants/strings.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/extensions/widget_extensions.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_elevated_button.dart';
import 'package:gpt_detector/feature/onboarding/presentation/bloc/onboarding_bloc.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              Image.asset(
                Assets.appIcon,
                height: context.veryHighValue2x,
                width: double.infinity,
              ),
              Column(
                children: [
                  Text(
                    Strings.appName,
                    style: context.textTheme.headlineMedium,
                  ),
                  Text(
                    Strings.infoText1,
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    Strings.infoText2,
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    Strings.infoText3,
                    style: context.textTheme.bodyLarge,
                  ),
                ]
                    .animate(interval: 600.ms)
                    .fadeIn(duration: 900.ms, delay: 300.ms)
                    .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
                    .spaceBetween(height: context.mediumValue),
              ),
              const Spacer(),
              SizedBox(
                width: context.width,
                height: context.highValue,
                child: GPTElevatedButton(
                  onPressed: () => context.read<OnboardingBloc>().add(const OnboardingEvent.completeOnboarding()),
                  child: const Text(Strings.getStarted),
                ),
              ),
            ].spaceBetween(
              height: context.mediumValue,
            ),
          ),
        ),
      ),
    );
  }
}
