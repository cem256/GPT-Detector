import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gpt_detector/app/constants/ad_constants.dart';
import 'package:gpt_detector/app/constants/string_constants.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/app/theme/theme_constants.dart';
import 'package:gpt_detector/app/widgets/gpt_elevated_button.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/utils/logger/logger_utils.dart';
import 'package:gpt_detector/core/utils/rate_app/rate_app.dart';
import 'package:gpt_detector/core/utils/snackbar/snackbar_utils.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/presentation/cubit/detector_cubit.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_card.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_drawer.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_faq_dialog.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_text_field.dart';
import 'package:gpt_detector/locator.dart';

class DetectView extends StatelessWidget {
  const DetectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.appName),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showDialog<void>(context: context, builder: (context) => const GPTFAQDialog()),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      drawer: const GPTDrawer(),
      body: BlocProvider(
        create: (context) => Locator.instance<DetectorCubit>()
          ..initialize()
          ..requestGdprConsent(),
        child: _DetectViewBody(),
      ),
    );
  }
}

class _DetectViewBody extends StatefulWidget {
  @override
  State<_DetectViewBody> createState() => _DetectViewBodyState();
}

class _DetectViewBodyState extends State<_DetectViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetectorCubit, DetectorState>(
      builder: (context, state) {
        return state.requestingGdprConsent ? const Center(child: CircularProgressIndicator()) : const _DetectorBody();
      },
    );
  }
}

class _DetectorBody extends StatefulWidget {
  const _DetectorBody();

  @override
  State<_DetectorBody> createState() => _DetectorBodyState();
}

class _DetectorBodyState extends State<_DetectorBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetectorCubit, DetectorState>(
      listener: (context, state) async {
        if (state.status.isSubmissionFailure) {
          state.failure!.whenOrNull(
            networkFailure: () => SnackbarUtils.showSnackbar(
              context: context,
              message: context.l10n.networkFailure,
            ),
            noInternetFailure: () => SnackbarUtils.showSnackbar(
              context: context,
              message: context.l10n.noInternetFailure,
            ),
          );
        }
        if (state.status.isSubmissionSuccess && !state.result.isSupportedLanguage) {
          SnackbarUtils.showSnackbar(
            context: context,
            message: context.l10n.unsupportedLanguage,
          );
        }
        if (state.showRateAppDialog) {
          await RateAppUtils.rateApp();
        }
        if (state.showInterstitialAd) {
          await InterstitialAd.load(
            adUnitId: AdConstants.interstitialAdUnitId,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                LoggerUtils.instance.logInfo('InterstitialAd loaded successfully');
                ad
                  ..fullScreenContentCallback = FullScreenContentCallback(
                    onAdDismissedFullScreenContent: (ad) {
                      LoggerUtils.instance.logInfo('InterstitialAd dismissed');
                      ad.dispose();
                    },
                    onAdFailedToShowFullScreenContent: (ad, error) {
                      LoggerUtils.instance.logError('InterstitialAd failed to show: $error');
                      ad.dispose();
                    },
                  )
                  ..show();
              },
              onAdFailedToLoad: (LoadAdError error) {
                LoggerUtils.instance.logError('InterstitialAd failed to load: $error');
              },
            ),
          );
        }
      },
      child: BlocBuilder<DetectorCubit, DetectorState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BlocSelector<DetectorCubit, DetectorState, Classification>(
                          selector: (state) => state.result.classification,
                          builder: (context, state) {
                            final cardColor = state.getCardColor(context.theme);
                            // Calculates the text color based on the card color
                            final textColor = cardColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
                            return GPTCard(
                              color: cardColor,
                              child: Padding(
                                padding: context.paddingAllLow,
                                child: Text(
                                  state.convertToLocalizedString(context.l10n),
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: ThemeConstants.fontWeightSemiBold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.defaultValue,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        GPTTextField(
                          controller: _controller,
                          onChanged: (text) => context.read<DetectorCubit>().textChanged(text: text),
                          hintText: context.l10n.textFieldHint,
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            color: context.colorScheme.primary,
                            onPressed: () {
                              _controller.clear();
                              context.read<DetectorCubit>().clearTextPressed();
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.photo_library),
                                color: context.colorScheme.primary,
                                onPressed: () async {
                                  // Control the gallery permission
                                  await context.read<DetectorCubit>().checkGalleryPermission();
                                  if (!context.mounted) return;
                                  // If there is no gallery access, then exit
                                  if (!(context.read<DetectorCubit>().state.hasGalleryPermission ?? true)) return;
                                  if (!context.mounted) return;
                                  await context.read<DetectorCubit>().ocrFromGalleryPressed();
                                  if (!context.mounted) return;
                                  _controller.text = context.read<DetectorCubit>().state.userInput.value;
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.photo_camera),
                                color: context.colorScheme.primary,
                                onPressed: () async {
                                  // Control the camera permission
                                  await context.read<DetectorCubit>().checkCameraPermission();
                                  if (!context.mounted) return;
                                  // If there is no camera access, then exit
                                  if (!(context.read<DetectorCubit>().state.hasCameraPermission ?? true)) return;
                                  if (!context.mounted) return;
                                  await context.read<DetectorCubit>().ocrFromCameraPressed();
                                  if (!context.mounted) return;
                                  _controller.text = context.read<DetectorCubit>().state.userInput.value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: context.defaultValue,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocSelector<DetectorCubit, DetectorState, UserInputFormError?>(
                        selector: (state) => state.userInput.error,
                        builder: (context, state) {
                          switch (state) {
                            case UserInputFormError.tooShort:
                              return Flexible(
                                child: Text(
                                  context.l10n.textFieldHelperShortText,
                                  style: context.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            case UserInputFormError.tooLong:
                              return Flexible(
                                child: Text(
                                  context.l10n.textFieldHelperLongText,
                                  style: context.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            case null:
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                      BlocSelector<DetectorCubit, DetectorState, int>(
                        selector: (state) => state.userInput.value.trim().length,
                        builder: (context, state) {
                          return Text(
                            context.l10n.textFieldCounterText(state),
                            style: context.textTheme.bodySmall,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.defaultValue,
                  ),
                  BlocBuilder<DetectorCubit, DetectorState>(
                    buildWhen: (previous, current) =>
                        previous.status.isSubmissionInProgress != current.status.isSubmissionInProgress,
                    builder: (context, state) {
                      return GPTElevatedButton(
                        showingLoadingIndicator: state.status.isSubmissionInProgress,
                        text: context.l10n.analyzeText,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          context.read<DetectorCubit>().detectionRequested(
                                context: context,
                                text: _controller.text,
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
