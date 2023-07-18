import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:injectable/injectable.dart';

abstract interface class LanguageIdentifierClient {
  Future<String> identifyLanguage({required String userInput});
}

@Injectable(as: LanguageIdentifierClient)
final class LanguageIdentifierClientImpl implements LanguageIdentifierClient {
  LanguageIdentifierClientImpl({required LanguageIdentifier languageIdentifier})
      : _languageIdentifier = languageIdentifier;

  final LanguageIdentifier _languageIdentifier;

  @override
  Future<String> identifyLanguage({required String userInput}) async {
    final recognizedLanguage = await _languageIdentifier.identifyLanguage(userInput);
    await _languageIdentifier.close();

    return recognizedLanguage;
  }
}
