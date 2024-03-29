import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';

abstract interface class TextRecognizerClient {
  Future<String> recognizeTextFormFilePath({required String filePath});
}

@Injectable(as: TextRecognizerClient)
final class TextRecognizerClientImpl implements TextRecognizerClient {
  TextRecognizerClientImpl({required TextRecognizer textRecognizer}) : _textRecognizer = textRecognizer;

  final TextRecognizer _textRecognizer;

  @override
  Future<String> recognizeTextFormFilePath({required String filePath}) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    await _textRecognizer.close();

    return recognizedText.text;
  }
}
