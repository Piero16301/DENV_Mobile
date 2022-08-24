import 'dart:ui';

import 'package:denv_mobile/providers/providers.dart';
import 'package:denv_mobile/services/services.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'pages/pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeModeApp.init(
    darkMode:
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark,
  );
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  initializeDateFormatting('es_ES', null).then((_) => runApp(const MyApp()));
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
            ChangeNotifierProvider(create: (_) => CaseReportProvider()),
            ChangeNotifierProvider(create: (_) => CaseReportService()),
            ChangeNotifierProvider(create: (_) => PropagationZoneProvider()),
            ChangeNotifierProvider(create: (_) => PropagationZoneService()),
            ChangeNotifierProvider(create: (_) => MapProvider()),
            ChangeNotifierProvider(create: (_) => MapService()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DENV',
            initialRoute: '/home',
            routes: {
              '/home': (context) => const HomePage(),
              '/map': (context) => const MapPage(),
              '/create_case_report': (context) => const CreateCaseReport(),
              '/create_propagation_zone': (context) =>
                  const CreatePropagationZone(),
            },
            theme: ThemeModeApp.getTheme(),
          ),
        );
      },
    );
  }
}
