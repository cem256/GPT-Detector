import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_detector/app/constants/asset_constants.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/app/router/app_router.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/extensions/widget_extensions.dart';
import 'package:gpt_detector/feature/detector/presentation/view/detect_view.dart';
import 'package:gpt_detector/feature/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:gpt_detector/injection.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<OnboardingCubit>(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AssetConstants.appIcon,
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
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await context.read<OnboardingCubit>().completeOnboarding();
                if (context.mounted) {
                  unawaited(AppRouter.pushReplacement(context, const DetectView()));
                }
              },
              child: Text(context.l10n.getStarted),
            ),
          ]
              .animate(interval: 400.ms)
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)
              .spaceBetween(height: context.mediumValue),
        ),
      ),
    );
  }
}
