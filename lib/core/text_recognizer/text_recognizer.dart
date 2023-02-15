// ignore_for_file: one_member_abstracts

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';

abstract class TextRecognizerUtils {
  Future<String> recognizeTextFormFilePath({required String filePath});
}

@LazySingleton(as: TextRecognizerUtils)
class TextRecognizerUtilsImpl implements TextRecognizerUtils {
  TextRecognizerUtilsImpl({required TextRecognizer textRecognizer}) : _textRecognizer = textRecognizer;

  final TextRecognizer _textRecognizer;

  @override
  Future<String> recognizeTextFormFilePath({required String filePath}) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    await _textRecognizer.close();

    return recognizedText.text;
  }
}
