part of 'theme_cubit.dart';

@freezed
class ThemeState with _$ThemeState {
  factory ThemeState({required ThemeMode themeMode}) = _ThemeState;

  const ThemeState._();

  factory ThemeState.initial() => ThemeState(themeMode: ThemeMode.system);

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(themeMode: ThemeMode.values[map['themeMode'] as int]);
  }
  Map<String, dynamic> toMap() {
    return {'themeMode': themeMode.index};
  }
}
