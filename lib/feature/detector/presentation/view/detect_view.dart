import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/extensions/widget_extensions.dart';
import 'package:gpt_detector/core/utils/snackbar/snackbar_utils.dart';
import 'package:gpt_detector/feature/detector/presentation/cubit/detector_cubit.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_card.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_drawer.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_text_field.dart';
import 'package:gpt_detector/injection.dart';

class DetectView extends StatelessWidget {
  const DetectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
      ),
      drawer: const GPTDrawer(),
      body: BlocProvider(
        create: (context) => getIt<DetectorCubit>(),
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
      },
      child: SafeArea(
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GPTCard(
                      color: context.theme.colorScheme.tertiaryContainer,
                      child: SizedBox(
                        height: context.highValue,
                        child: Center(
                          child: BlocSelector<DetectorCubit, DetectorState, double>(
                            selector: (state) => state.result.realProb,
                            builder: (context, state) {
                              return Countup(
                                begin: 0,
                                end: state,
                                precision: 2,
                                duration: context.durationHigh,
                                suffix: context.l10n.percentOriginal,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GPTCard(
                      color: context.theme.colorScheme.errorContainer,
                      child: SizedBox(
                        height: context.highValue,
                        child: Center(
                          child: BlocSelector<DetectorCubit, DetectorState, double>(
                            selector: (state) => state.result.fakeProb,
                            builder: (context, state) {
                              return Countup(
                                precision: 2,
                                begin: 0,
                                end: state,
                                duration: context.durationHigh,
                                suffix: context.l10n.percentAI,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ].spaceBetween(width: context.mediumValue),
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
                              if (context.mounted) {
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
                  BlocSelector<DetectorCubit, DetectorState, bool>(
                    selector: (state) => state.status.isValidated,
                    builder: (context, state) {
                      return !state
                          ? Text(
                              context.l10n.textFieldHelper,
                              style: context.textTheme.bodySmall,
                            )
                          : const SizedBox.shrink();
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
                        ? () => context.read<DetectorCubit>().detectionRequested(text: state.userInput.value)
                        : null,
                    child: state.status.isSubmissionInProgress
                        ? const CircularProgressIndicator.adaptive()
                        : Text(context.l10n.analyzeText),
                  );
                },
              ),
            ].spaceBetween(height: context.mediumValue),
          ),
        ),
      ),
    );
  }
}
