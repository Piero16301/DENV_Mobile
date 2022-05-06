import 'package:flutter/material.dart';

import 'package:deteccion_zonas_dengue_mobile/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData currentTheme;
  late String currentThemeName;

  ThemeProvider({required bool isDarkMode}) {
    currentTheme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    currentThemeName = isDarkMode ? 'dark' : 'light';
  }

  setLightMode() {
    currentTheme = AppTheme.lightTheme;
    currentThemeName = 'light';
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = AppTheme.darkTheme;
    currentThemeName = 'dark';
    notifyListeners();
  }
}
