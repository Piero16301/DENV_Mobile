import 'package:flutter/material.dart';

class ThemeModeApp {
  static late bool _isDarkMode;

  static void init({required bool isDarkMode}) {
    _isDarkMode = isDarkMode;
  }

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlue,
        onPrimary: Colors.white,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.lightBlue,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlueAccent,
        onPrimary: Colors.black,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.lightBlueAccent,
    ),
  );

  static ThemeData getTheme() {
    return _isDarkMode ? darkTheme : lightTheme;
  }

  static void changeTheme(isDarkMode) {
    _isDarkMode = isDarkMode;
  }
}
