import 'dart:ui';

class ThemeNotifier {
  ThemeNotifier(this.appBrightness);

  // ignore: prefer_typing_uninitialized_variables
  final appBrightness;

  changeBrightness({required Brightness brightness}) {
    appBrightness.value = brightness;
  }
}
