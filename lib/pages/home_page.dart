import 'package:denv_mobile/pages/pages.dart';
import 'package:denv_mobile/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    if (!locationProvider.locationEnabled) {
      return const DeniedLocationPage();
    }

    if (locationProvider.isGettingAddress) {
      return const LoadingLocationPage();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    MapButton(),
                  ],
                ),
              ),
              const Text(
                'Ubicación actual',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${locationProvider.currentAddress!.formattedAddress}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapButton extends StatefulWidget {
  const MapButton({Key? key}) : super(key: key);

  @override
  State<MapButton> createState() => _MapButtonState();
}

class _MapButtonState extends State<MapButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (isLoading) return;

        setState(() => isLoading = true);
        await Future.delayed(const Duration(seconds: 3));
        setState(() => isLoading = false);
      },
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const Text('Mostrar mapa'),
    );
  }
}
