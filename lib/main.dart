import 'dart:ui';

import 'package:denv_mobile/providers/providers.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'pages/pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeModeApp.init(
    isDarkMode:
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark,
  );
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
        ThemeModeApp.changeTheme(value == Brightness.dark);

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
            theme: ThemeModeApp.getTheme(),
          ),
        );
      },
    );
  }
}
