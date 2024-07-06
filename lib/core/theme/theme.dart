import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

/// The `AppTheme` class defines a dark theme mode for a Flutter application with specific border styles
/// and color schemes.
class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 3.0),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(Pallete.borderColor),
      focusedBorder: _border(Pallete.gradient2),
    ),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Pallete.backgroundColor),
  );
}
