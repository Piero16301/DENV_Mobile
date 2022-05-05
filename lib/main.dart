import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:deteccion_zonas_dengue_mobile/pages/pages.dart';
import 'package:deteccion_zonas_dengue_mobile/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => LocationProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DENV',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => const HomePage(),
      },
    );
  }
}
