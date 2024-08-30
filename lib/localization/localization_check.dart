import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationChecker {
  static void changeLanguage(BuildContext context, String languageCode) {
    Locale? newLocale = _getLocaleFromLanguageCode(languageCode);
    EasyLocalization.of(context)!.setLocale(newLocale);
  }

  static Locale _getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'mr': // Marathi
        return const Locale('mr', 'IN');
      case 'en': // English
        return const Locale('en', 'US');
      case 'hi': // Hindi
        return const Locale('hi', 'IN');
      case 'te': // Telugu
        return const Locale('te', 'IN');
      default:
        return const Locale('en', 'US'); // Fallback to English
    }
  }
}
