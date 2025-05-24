import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A ChangeNotifier that exposes ThemeMode and persists it.
class ThemeProvider with ChangeNotifier {
  static const _key = 'isDarkMode';

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;
  bool get isDarkMode => _mode == ThemeMode.dark;

  ThemeProvider() {
    _loadFromPrefs();
  }

  /// Toggle between dark/light and persist.
  Future<void> toggleTheme(bool darkOn) async {
    _mode = darkOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, darkOn);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final darkOn = prefs.getBool(_key) ?? false;
    _mode = darkOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
