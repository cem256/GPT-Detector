import 'package:package_info_plus/package_info_plus.dart';

abstract final class PackageInfoUtils {
  static late final PackageInfo _packageInfo;

  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  static String getAppVersion() {
    return _packageInfo.version;
  }
}
