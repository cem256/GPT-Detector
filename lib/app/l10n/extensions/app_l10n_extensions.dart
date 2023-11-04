import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppL10nExtension on Locale {
  String humanLanguage(BuildContext context) => LocaleNames.of(context)?.nameOf('${languageCode}_$countryCode') ?? '';
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
