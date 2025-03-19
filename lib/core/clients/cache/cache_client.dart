// ignore_for_file: avoid_positional_boolean_parameters

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class CacheClient {
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);
  Future<void> setInt(String key, int value);
  int? getInt(String key);
}

@Injectable(as: CacheClient)
final class CacheClientImpl implements CacheClient {
  CacheClientImpl({required SharedPreferences sharedPreferences}) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;
  @override
  bool? getBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  @override
  int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }
}
