import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Color.fromARGB(255, 177, 174, 174), // White
    primary: Color.fromARGB(255, 113, 43, 143), // Purple
    secondary: Color(0xFF6A1B9A), // Darker Purple
    tertiary: Color(0xFF6200EA), // Deep Purple
    inversePrimary: Color(0xFF121212), // Dark Grey (for contrast)
  ),
);
