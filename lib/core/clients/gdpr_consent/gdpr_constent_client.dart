import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gpt_detector/core/utils/logger/logger_utils.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GdprConsentClient {
  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();

    final params = ConsentRequestParameters(
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
      ),
    );
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadConsentForm();
        } else {
          await _initialize();
        }

        completer.complete();
      },
      (error) {
        LoggerUtils.instance.logError('Failed to request consent info update: ${error.message}');
        completer.complete(error);
      },
    );

    return completer.future;
  }

  Future<FormError?> _loadConsentForm() async {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm(
      (consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((formError) {
            completer.complete(_loadConsentForm());
          });
        } else {
          await _initialize();
          completer.complete();
        }
      },
      (error) {
        LoggerUtils.instance.logError('Failed to load consent form: ${error.message}');
        completer.complete(error);
      },
    );

    return completer.future;
  }

  Future<void> _initialize() async {
    await MobileAds.instance.initialize();
  }
}
