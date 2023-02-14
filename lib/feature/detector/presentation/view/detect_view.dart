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
                          child: BlocBuilder<DetectorCubit, DetectorState>(
                            buildWhen: (previous, current) => previous.result.realProb != current.result.realProb,
                            builder: (context, state) {
                              return Countup(
                                begin: 0,
                                end: state.result.realProb,
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
                          child: BlocBuilder<DetectorCubit, DetectorState>(
                            buildWhen: (previous, current) => previous.result.fakeProb != current.result.realProb,
                            builder: (context, state) {
                              return Countup(
                                precision: 2,
                                begin: 0,
                                end: state.result.fakeProb,
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
                      child: BlocListener<DetectorCubit, DetectorState>(
                        listenWhen: (previous, current) {
                          return previous.userInput.value != current.userInput.value &&
                              _controller.text != current.userInput.value;
                        },
                        listener: (context, state) {
                          _controller.text = state.userInput.value;
                        },
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => context.read<DetectorCubit>().clearTextPressed(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.photo_library),
                            onPressed: () => context.read<DetectorCubit>().ocrFromGalleryPressed(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_camera),
                            onPressed: () => context.read<DetectorCubit>().ocrFromCameraPressed(),
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
                  Text(
                    context.l10n.textFieldHelper,
                    style: context.textTheme.bodySmall,
                  ),
                  BlocBuilder<DetectorCubit, DetectorState>(
                    buildWhen: (previous, current) => previous.result.allTokens != current.result.allTokens,
                    builder: (context, state) {
                      return Text(
                        context.l10n.textFieldCounterText(state.result.allTokens),
                        style: context.textTheme.bodySmall,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: context.width,
                height: context.highValue,
                child: BlocBuilder<DetectorCubit, DetectorState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status.isValidated
                          ? () => context.read<DetectorCubit>().detectionRequested(text: state.userInput.value)
                          : null,
                      child: state.status.isSubmissionInProgress
                          ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                          : Text(context.l10n.analyzeText),
                    );
                  },
                ),
              ),
            ].spaceBetween(height: context.mediumValue),
          ),
        ),
      ),
    );
  }
}
