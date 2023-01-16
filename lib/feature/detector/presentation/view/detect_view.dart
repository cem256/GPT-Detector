import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/enums/page_state.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../locator.dart';
import '../bloc/detector_bloc.dart';
import '../widgets/gpt_app_bar.dart';
import '../widgets/gpt_card.dart';
import '../widgets/gpt_drawer.dart';
import '../widgets/gpt_elevated_button.dart';
import '../widgets/gpt_text_field.dart';

class DetectView extends StatelessWidget {
  const DetectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GPTAppBar(
        title: Strings.appName,
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
        if (state.pageState == PageState.failure) {
          state.failure!.when(
            networkFailure: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: SizedBox(
                    height: context.highValue,
                    child: const Text(
                      Strings.networkFailure,
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
                    child: const Text(
                      Strings.noInternetFailure,
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
                              suffix: Strings.percentOriginal,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: context.mediumValue,
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
                              suffix: Strings.percentAI,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: context.mediumValue,
            ),
            Expanded(
              child: Stack(
                children: [
                  BlocBuilder<DetectorBloc, DetectorState>(
                    builder: (context, state) {
                      return GPTTextField(
                        controller: _controller,
                        hintText: Strings.textFieldHint,
                        errorText: state.isValidInput ? null : Strings.textFieldError,
                        helperText: Strings.textFieldHelper,
                        counterText: '${Strings.textFieldCounter}  ${state.result.allTokens}',
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      splashColor: Colors.transparent,
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
            SizedBox(
              height: context.mediumValue,
            ),
            SizedBox(
              width: context.width,
              height: context.highValue,
              child: BlocBuilder<DetectorBloc, DetectorState>(
                builder: (context, state) {
                  return GPTElevatedButton(
                    onPressed: state.pageState != PageState.loading
                        ? () => context
                            .read<DetectorBloc>()
                            .add(DetectorEvent.detectionRequested(textInput: _controller.text))
                        : null,
                    child: state.pageState == PageState.loading
                        ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                        : const Text(Strings.analyzeButton),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
