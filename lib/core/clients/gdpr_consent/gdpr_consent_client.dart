import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gpt_detector/core/utils/logger/logger_utils.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GdprConsentClient {
  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(
        consentDebugSettings: ConsentDebugSettings(
          debugGeography: DebugGeography.debugGeographyEea,
        ),
      ),
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

  Future<bool> isUnderGDPR() async {
    try {
      final completer = Completer<bool>();

      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(
          consentDebugSettings: ConsentDebugSettings(
            debugGeography: DebugGeography.debugGeographyEea,
          ),
        ),
        () async {
          final isFormAvailable = await ConsentInformation.instance.isConsentFormAvailable();
          completer.complete(isFormAvailable);
        },
        (error) {
          LoggerUtils.instance.logError('Failed to request consent info update: ${error.message}');
          completer.complete(false);
        },
      );

      return completer.future;
    } catch (e) {
      LoggerUtils.instance.logError('Error checking GDPR status: $e');
      return false;
    }
  }

  Future<bool> changePrivacyPreferences() async {
    final completer = Completer<bool>();

    ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(
          consentDebugSettings: ConsentDebugSettings(
            debugGeography: DebugGeography.debugGeographyEea,
          ),
        ), () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        ConsentForm.loadConsentForm((consentForm) {
          consentForm.show((formError) async {
            await _initialize();
            completer.complete(true);
          });
        }, (formError) {
          LoggerUtils.instance.logError('Failed to change privacy preferences: ${formError.message}');
          completer.complete(false);
        });
      } else {
        completer.complete(false);
      }
    }, (error) {
      LoggerUtils.instance.logError('Failed to change privacy preferences: ${error.message}');
      completer.complete(false);
    });

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
