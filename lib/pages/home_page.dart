import 'package:deteccion_zonas_dengue_mobile/shared_preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:deteccion_zonas_dengue_mobile/providers/providers.dart';
import 'package:deteccion_zonas_dengue_mobile/theme/app_theme.dart';
import 'package:deteccion_zonas_dengue_mobile/pages/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    if (!locationProvider.locationEnabled) {
      return const LocationDeniedPage();
    }

    if (locationProvider.isGettingAddress) {
      return const GettingAddressPage();
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildDarkModeSwitch(context),
          Center(
            child: Text('${locationProvider.currentAddress!.formattedAddress}'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

        },
        label: const Text(
          'Nuevo reporte',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        icon: const Icon(
          Icons.note_add_outlined,
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  Positioned _buildDarkModeSwitch(BuildContext context) {
    return Positioned(
      top: 30,
      left: 10,
      child: Row(
        children: [
          Switch(
            value: Preferences.isDarkMode,
            activeColor: AppTheme.primary,
            onChanged: (value) {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              setState(() {
                Preferences.isDarkMode = value;
                if (themeProvider.currentThemeName == 'light') {
                  themeProvider.setDarkMode();
                } else {
                  themeProvider.setLightMode();
                }
              });
            },
          ),
          const Text(
            'Modo oscuro',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
