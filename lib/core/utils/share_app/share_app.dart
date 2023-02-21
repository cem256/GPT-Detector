import 'package:gpt_detector/app/constants/strings.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareAppUtils {
  static Future<void> shareApp() async {
    await Share.share(Strings.googlePlayUrl);
  }
}
