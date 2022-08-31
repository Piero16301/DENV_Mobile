import 'package:flutter/material.dart';

class PropagationZonePage extends StatelessWidget {
  const PropagationZonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la zona de propagación'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Zona de propagación'),
      ),
    );
  }
}
