import 'package:flutter/material.dart';

import 'package:deteccion_zonas_dengue_mobile/theme/app_theme.dart';

class GettingAddressPage extends StatelessWidget {
  const GettingAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Obteniendo ubicación',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Por favor, espere...',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}
