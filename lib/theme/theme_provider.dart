import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workify/theme/dark_mode.dart';
import 'package:workify/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkMode; // Default theme is dark mode

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  ThemeProvider() {
    _loadTheme(); // Load saved theme when provider is initialized
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isDarkMode) {
      _themeData = lightMode;
      prefs.setBool('isDarkMode', false); // Save theme preference
    } else {
      _themeData = darkMode;
      prefs.setBool('isDarkMode', true);
    }
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? true; // Default to dark mode
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners();
  }
}
