import 'package:flutter/material.dart';

ThemeData DarkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade700,
    // Remove tertiary if not supported
    tertiary: Colors.grey.shade800,
  ),
);
