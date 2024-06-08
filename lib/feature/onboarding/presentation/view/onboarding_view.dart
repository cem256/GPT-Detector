import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_detector/app/constants/asset_constants.dart';
import 'package:gpt_detector/app/constants/duration_constants.dart';
import 'package:gpt_detector/app/constants/string_constants.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/app/router/app_router.dart';
import 'package:gpt_detector/app/widgets/gpt_elevated_button.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/feature/detector/presentation/view/detect_view.dart';
import 'package:gpt_detector/feature/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:gpt_detector/locator.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => Locator.instance<OnboardingCubit>(),
        child: const _OnboardingViewBody(),
      ),
    );
  }
}

class _OnboardingViewBody extends StatelessWidget {
  const _OnboardingViewBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.paddingAllDefault,
        child: Column(
          children: [
            Center(
              child: Image.asset(
                AssetConstants.appIcon,
                height: context.veryHighValue2x,
                width: double.infinity,
              ),
            ),
            Center(
              child: Text(
                StringConstants.appName,
                style: context.textTheme.headlineMedium,
              ),
            ),
            SizedBox(
              height: context.highValue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Icon(
                    Icons.hail_rounded,
                    size: context.mediumValue,
                  ),
                ),
                SizedBox(
                  width: context.lowValue,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    context.l10n.onboardingInfo1,
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: context.defaultValue,
            ),
            Row(
              children: [
                Expanded(
                  child: Icon(
                    Icons.language,
                    size: context.mediumValue,
                  ),
                ),
                SizedBox(
                  width: context.lowValue,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    context.l10n.onboardingInfo2,
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: context.defaultValue,
            ),
            GPTElevatedButton(
              text: context.l10n.getStarted,
              onPressed: () async {
                await context.read<OnboardingCubit>().completeOnboarding();
                if (!context.mounted) return;
                unawaited(AppRouter.pushReplacement(context, const DetectView()));
              },
            ),
          ]
              .animate(interval: DurationConstants.ms250())
              .fadeIn(duration: DurationConstants.ms500(), delay: DurationConstants.ms250())
              .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
        ),
      ),
    );
  }
}
