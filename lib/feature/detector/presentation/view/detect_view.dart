import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/extensions/widget_extensions.dart';
import 'package:gpt_detector/core/permission/permission_manager.dart';
import 'package:gpt_detector/core/utils/image_picker/image_picker.dart';
import 'package:gpt_detector/core/utils/permission_handler/permission_handler.dart';
import 'package:gpt_detector/core/utils/snackbar/snackbar_utils.dart';
import 'package:gpt_detector/core/utils/text_recognizer/text_recognizer.dart';
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetectorBloc, DetectorState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          state.failure!.when(
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
                        onChanged: (text) => context.read<DetectorBloc>().add(DetectorEvent.textChanged(text: text)),
                        hintText: context.l10n.textFieldHint,
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        context.read<DetectorBloc>().add(const DetectorEvent.clearTextPressed());
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
                          onPressed: () {
                            OCRManager(
                              permissionHandler: PermissionHandlerUtilsImpl(),
                              imagePicker: ImagePickerUtilsImpl(),
                              textRecognizer: TextRecognizerUtilsImpl(),
                            ).ocrFromGallery();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo_camera),
                          onPressed: () {
                            OCRManager(
                              permissionHandler: PermissionHandlerUtilsImpl(),
                              imagePicker: ImagePickerUtilsImpl(),
                              textRecognizer: TextRecognizerUtilsImpl(),
                            ).ocrFromCamera();
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
                Text(
                  context.l10n.textFieldHelper,
                  style: context.textTheme.bodySmall,
                ),
                BlocBuilder<DetectorBloc, DetectorState>(
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
            BlocBuilder<DetectorBloc, DetectorState>(
              builder: (context, state) {
                return SizedBox(
                  width: context.width,
                  height: context.highValue,
                  child: GPTElevatedButton(
                    onPressed: state.status.isValidated
                        ? () => context
                            .read<DetectorBloc>()
                            .add(DetectorEvent.detectionRequested(userInput: _controller.text))
                        : null,
                    child: state.status.isSubmissionInProgress
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
