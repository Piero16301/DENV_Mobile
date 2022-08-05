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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    MapButton(),
                    NewCaseReportButton(),
                    NewPropagationZoneButton(),
                  ],
                ),
              ),
              const Text(
                'Tú ubicación',
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

class MapButton extends StatelessWidget {
  const MapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: const [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.map_rounded,
                    // color: Colors.white,
                  ),
                  iconSize: 150,
                ),
                // const SizedBox(
                //   height: 200,
                //   width: 200,
                //   child: CircularProgressIndicator(
                //     strokeWidth: 7,
                //     value: 0.7,
                //   ),
                // ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Mostar mapa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

class NewCaseReportButton extends StatelessWidget {
  const NewCaseReportButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: const Text(
          'Nuevo reporte de caso',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class NewPropagationZoneButton extends StatelessWidget {
  const NewPropagationZoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: const Text(
          'Nueva zona de propagación',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
