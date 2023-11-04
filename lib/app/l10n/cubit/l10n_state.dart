part of 'l10n_cubit.dart';

@freezed
class L10nState with _$L10nState {
  factory L10nState({required Locale locale}) = _L10nState;

  const L10nState._();

  factory L10nState.initial() => L10nState(locale: AppL10n.fallbackLocale);

  factory L10nState.fromMap(Map<String, dynamic> map) {
    return L10nState(locale: AppL10n.supportedLocales.firstWhere((e) => e.languageCode == map['locale']));
  }

  Map<String, dynamic> toMap() {
    return {'locale': locale.languageCode};
  }
}
