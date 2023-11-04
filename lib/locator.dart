import 'package:get_it/get_it.dart';
import 'package:gpt_detector/core/utils/package_info/package_info_utils.dart';
import 'package:gpt_detector/locator.config.dart';
import 'package:injectable/injectable.dart';

@InjectableInit()

/// [Locator] is responsible for locating and registering all the
/// services of the application.
abstract final class Locator {
  /// [GetIt] instance
  static final instance = GetIt.instance;

  /// Responsible for registering all the dependencies
  static Future<void> locateServices() async {
    await PackageInfoUtils.init();
    await instance.init();
  }
}
