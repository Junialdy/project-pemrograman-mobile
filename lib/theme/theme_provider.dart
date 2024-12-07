import 'package:flutter/material.dart';
import 'package:habittute/theme/dark_mode.dart';
import 'package:habittute/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially, light mode
  ThemeData _themeData = LightMode;

  // Get current theme
  ThemeData get currentTheme => _themeData;

  // Check if current theme is dark mode
  bool get isDarkMode => _themeData == DarkMode;

  // Set theme
  set currentTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle theme
  void toggleTheme() {
    if (_themeData == LightMode) {
      currentTheme = DarkMode; // Use setter
    } else {
      currentTheme = LightMode; // Use setter
    }
  }
}
