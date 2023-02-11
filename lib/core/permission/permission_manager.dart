import 'dart:developer';

import 'package:gpt_detector/core/utils/image_picker/image_picker.dart';
import 'package:gpt_detector/core/utils/permission_handler/permission_handler.dart';
import 'package:gpt_detector/core/utils/text_recognizer/text_recognizer.dart';

class OCRManager {
  OCRManager({
    required PermissionHandlerUtils permissionHandler,
    required ImagePickerUtils imagePicker,
    required TextRecognizerUtils textRecognizer,
  })  : _permissionHandler = permissionHandler,
        _imagePicker = imagePicker,
        _textRecognizer = textRecognizer;

  final PermissionHandlerUtils _permissionHandler;
  final ImagePickerUtils _imagePicker;
  final TextRecognizerUtils _textRecognizer;

  Future<String?> ocrFromGallery() async {
    final hasGalleryPermission = await _permissionHandler.hasGalleryPermission();
    if (hasGalleryPermission) {
      final file = await _imagePicker.selectFromGallery();
      if (file?.path != null) {
        final recognizedText = await _textRecognizer.recognizeText(file!.path);
        log('we are here "$recognizedText"');
        return recognizedText;
      }
      log(file?.path ?? 'no image selected');
    } else {
      await _permissionHandler.requestGalleryPermission();
    }
    return null;
  }

  Future<String?> ocrFromCamera() async {
    final hasCameraPermission = await _permissionHandler.hasCameraPermission();
    if (hasCameraPermission) {
      final file = await _imagePicker.takePhoto();
      if (file?.path != null) {
        final recognizedText = await _textRecognizer.recognizeText(file!.path);
        log(recognizedText);
        return recognizedText;
      }
      log(file?.path ?? 'no photo taken');
    } else {
      await _permissionHandler.requestCameraPermission();
    }
    return null;
  }
}
