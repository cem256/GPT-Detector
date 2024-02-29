part of 'l10n_cubit.dart';

@freezed
class L10nState with _$L10nState {
  factory L10nState({required Locale locale}) = _L10nState;

  const L10nState._();

  factory L10nState.initial() {
    //Find the device's current locale that matches one of the supported locales
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locales.firstWhere(
      (locale) => AppL10n.supportedLocales.contains(locale),
      orElse: () => AppL10n.fallbackLocale,
    );

    return L10nState(locale: deviceLocale);
  }

  factory L10nState.fromMap(Map<String, dynamic> map) {
    return L10nState(
      locale: AppL10n.supportedLocales.firstWhere(
        (e) => e.languageCode == map['locale'],
        orElse: () => AppL10n.fallbackLocale,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {'locale': locale.languageCode};
  }
}
