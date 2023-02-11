// ignore_for_file: one_member_abstracts

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class TextRecognizerUtils {
  Future<String> recognizeText(String filePath);
}

class TextRecognizerUtilsImpl implements TextRecognizerUtils {
  @override
  Future<String> recognizeText(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    return recognizedText.text;
  }
}
