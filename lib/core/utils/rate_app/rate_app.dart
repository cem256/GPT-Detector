import 'package:in_app_review/in_app_review.dart';

abstract final class RateAppUtils {
  static Future<void> rateApp() async {
    final inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }
}
