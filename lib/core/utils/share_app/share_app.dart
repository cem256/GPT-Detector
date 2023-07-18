import 'package:gpt_detector/app/constants/string_constants.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareAppUtils {
  static Future<void> shareApp() async {
    await Share.share(StringConstants.googlePlayUrl);
  }
}
