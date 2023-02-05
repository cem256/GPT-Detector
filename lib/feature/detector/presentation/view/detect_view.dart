// ignore_for_file: require_trailing_commas

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/extensions/widget_extensions.dart';
import 'package:gpt_detector/feature/detector/presentation/bloc/detector_bloc.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_app_bar.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_card.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_drawer.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_elevated_button.dart';
import 'package:gpt_detector/feature/detector/presentation/widgets/gpt_text_field.dart';
import 'package:gpt_detector/locator.dart';

class DetectView extends StatelessWidget {
  const DetectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GPTAppBar(
        title: context.l10n.appName,
      ),
      drawer: const GPTDrawer(),
      body: BlocProvider(
        create: (context) => getIt<DetectorBloc>(),
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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetectorBloc, DetectorState>(
      listener: (context, state) {
        if (state.detectorStatus == DetectorStatus.failure) {
          state.failure!.when(
            networkFailure: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: SizedBox(
                    height: context.highValue,
                    child: Text(
                      context.l10n.networkFailure,
                    ),
                  ),
                ),
              ),
            noInternetFailure: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: SizedBox(
                    height: context.highValue,
                    child: Text(
                      context.l10n.noInternetFailure,
                    ),
                  ),
                ),
              ),
          );
        }
      },
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
                        child: BlocBuilder<DetectorBloc, DetectorState>(
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
                        child: BlocBuilder<DetectorBloc, DetectorState>(
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
                  BlocBuilder<DetectorBloc, DetectorState>(
                    builder: (context, state) {
                      return GPTTextField(
                        controller: _controller,
                        hintText: context.l10n.textFieldHint,
                        errorText: state.isValidInput ? null : context.l10n.textFieldError,
                        helperText: context.l10n.textFieldHelper,
                        counterText: context.l10n.textFieldCounterText(state.result.allTokens),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        _controller.clear();
                        context.read<DetectorBloc>().add(const DetectorEvent.clearTextPressed());
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<DetectorBloc, DetectorState>(
              builder: (context, state) {
                return SizedBox(
                  width: context.width,
                  height: context.highValue,
                  child: GPTElevatedButton(
                    onPressed: state.detectorStatus != DetectorStatus.loading
                        ? () => context.read<DetectorBloc>().add(
                              DetectorEvent.detectionRequested(textInput: _controller.text),
                            )
                        : null,
                    child: state.detectorStatus == DetectorStatus.loading
                        ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                        : Text(context.l10n.analyzeText),
                  ),
                );
              },
            ),
          ].spaceBetween(height: context.mediumValue),
        ),
      ),
    );
  }
}
