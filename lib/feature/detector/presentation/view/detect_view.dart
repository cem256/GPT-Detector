import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/extensions/widget_extensions.dart';
import 'package:gpt_detector/core/utils/snackbar/snackbar_utils.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/presentation/cubit/detector_cubit.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_card.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_drawer.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_faq_dialog.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_language_dialog.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_text_field.dart';
import 'package:gpt_detector/locator.dart';

class DetectView extends StatelessWidget {
  const DetectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        actions: [
          IconButton(
            onPressed: () => showDialog<void>(context: context, builder: (context) => const GPTFAQDialog()),
            icon: const Icon(Icons.info),
          ),
          IconButton(
            onPressed: () => showDialog<void>(context: context, builder: (context) => const GPTLanguageDialog()),
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      drawer: const GPTDrawer(),
      body: BlocProvider(
        create: (context) => Locator.instance<DetectorCubit>(),
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
      listener: (context, state) {
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
      },
      child: SafeArea(
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
                        return GPTCard(
                          color: state.getCardColor(context.theme.colorScheme),
                          child: Padding(
                            padding: context.paddingAllLow,
                            child: Text(
                              state.convertToLocalizedString(context.l10n),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ].spaceBetween(width: context.defaultValue),
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
                            onPressed: () async {
                              await context.read<DetectorCubit>().ocrFromGalleryPressed();
                              if (mounted) {
                                _controller.text = context.read<DetectorCubit>().state.userInput.value;
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_camera),
                            onPressed: () async {
                              await context.read<DetectorCubit>().ocrFromCameraPressed();
                              if (context.mounted) {
                                _controller.text = context.read<DetectorCubit>().state.userInput.value;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        case UserInputFormError.tooLong:
                          return Flexible(
                            child: Text(
                              context.l10n.textFieldHelperLongText,
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
              BlocBuilder<DetectorCubit, DetectorState>(
                buildWhen: (previous, current) =>
                    (previous.status.isValidated && !previous.status.isSubmissionInProgress) !=
                    (current.status.isValidated && !current.status.isSubmissionInProgress),
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.status.isValidated && !state.status.isSubmissionInProgress
                        ? () => context.read<DetectorCubit>().detectionRequested(text: _controller.text)
                        : null,
                    child: state.status.isSubmissionInProgress
                        ? const CircularProgressIndicator.adaptive()
                        : Text(context.l10n.analyzeText),
                  );
                },
              ),
            ].spaceBetween(height: context.defaultValue),
          ),
        ),
      ),
    );
  }
}
