import 'package:flutter/material.dart';
import 'package:habittute/theme/dark_mode.dart';
import 'package:habittute/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially, light mode
  ThemeData _themeData = lightMode;

  // Get current theme
  ThemeData get themeData => _themeData;

  // Check if current theme is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // Set theme
  set currentTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      currentTheme = darkMode; // Use setter
    } else {
      currentTheme = lightMode; // Use setter
    }
  }
}
