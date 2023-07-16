import 'package:get_it/get_it.dart';
import 'package:gpt_detector/locator.config.dart';
import 'package:injectable/injectable.dart';

@InjectableInit()
abstract final class Locator {
  static final instance = GetIt.instance;

  static Future<void> locateServices() => instance.init();
}
