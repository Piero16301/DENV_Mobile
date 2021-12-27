import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

import 'package:deteccion_zonas_dengue/sources/pages/home_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detección de Zonas con Dengue',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => const HomePage(),
      },
      theme: ThemeData.dark(),
    );
  }
}
