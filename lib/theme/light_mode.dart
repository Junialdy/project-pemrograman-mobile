import 'package:flutter/material.dart';

ThemeData LightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    // Remove tertiary if not supported
    tertiary: Colors.white,
  ),
);
