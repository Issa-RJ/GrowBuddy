import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == 'en';

  void toggleLanguage(bool toEnglish) {
    _locale = Locale(toEnglish ? 'en' : 'ar');
    notifyListeners();
  }
}
