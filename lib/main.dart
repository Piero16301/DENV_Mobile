import 'dart:ui';

import 'package:denv_mobile/providers/providers.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/pages.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late ThemeNotifier _themeNotifier;
  late final WidgetsBinding _widgetsBinding;
  late final FlutterWindow _window;

  @override
  void initState() {
    _widgetsBinding = WidgetsBinding.instance;
    _widgetsBinding.addObserver(this);
    _window = _widgetsBinding.window;
    _themeNotifier = ThemeNotifier(
      ValueNotifier<Brightness>(_window.platformDispatcher.platformBrightness),
    );
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    _themeNotifier.changeBrightness(
      brightness: _window.platformDispatcher.platformBrightness,
    );
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: _themeNotifier.appBrightness,
      builder: (context, value, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LocationProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DENV',
            initialRoute: '/home',
            routes: {
              '/home': (context) => const HomePage(),
            },
            theme: (value.name == 'dark')
                ? ThemeData.dark().copyWith(
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
                  )
                : ThemeData.light().copyWith(
                    primaryColor: Colors.white,
                    scaffoldBackgroundColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white,
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
