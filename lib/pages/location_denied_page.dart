import 'package:flutter/material.dart';

class LocationDeniedPage extends StatelessWidget {
  const LocationDeniedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Para usar la applicación, debes activar la ubicación'),
      ),
    );
  }
}
