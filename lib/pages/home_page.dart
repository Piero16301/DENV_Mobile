import 'package:denv_mobile/models/models.dart';
import 'package:denv_mobile/pages/pages.dart';
import 'package:denv_mobile/providers/providers.dart';
import 'package:denv_mobile/services/services.dart';
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
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      MapButton(),
                      NewHomeInspectionButton(),
                      NewVectorRecordButton(),
                    ],
                  ),
                ),
              ),
              const Text(
                'Tú ubicación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
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
    final mapService = Provider.of<MapService>(context);
    final mapProvider = Provider.of<MapProvider>(context);

    return InkWell(
      onTap: mapService.isGettingHomeInspections ||
              mapService.isGettingVectorRecords
          ? null
          : () async {
              List responses = await Future.wait([
                mapService.getHomeInspectionsSummarized(),
                mapService.getVectorRecordsSummarized(),
              ]);

              final homeInspectionsSummarized =
                  responses[0] as List<HomeInspectionSummarizedModel>?;
              final vectorRecordsSummarized =
                  responses[1] as List<VectorRecordSummarizedModel>?;

              if (homeInspectionsSummarized != null &&
                  vectorRecordsSummarized != null) {
                mapProvider
                    .setHomeInspectionsSummarized(homeInspectionsSummarized);
                mapProvider.setVectorRecordsSummarized(vectorRecordsSummarized);

                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/map');
              } else {
                await _showErrorDialog(context: context);
              }
            },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.map_rounded,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  iconSize: 150,
                ),
                AnimatedOpacity(
                  opacity: mapService.isGettingHomeInspections ||
                          mapService.isGettingVectorRecords
                      ? 1.0
                      : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: const SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 7,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: mapService.isGettingHomeInspections ||
                      mapService.isGettingVectorRecords
                  ? 0.0
                  : 1.0,
              duration: const Duration(milliseconds: 500),
              child: const Text(
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
    );
  }

  Future<void> _showErrorDialog({
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Error',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Text(
            'Ha ocurrido un error al obtener los casos de dengue y zonas de propagación, por favor intente de nuevo.',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 10),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                elevation: 1,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NewHomeInspectionButton extends StatelessWidget {
  const NewHomeInspectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Hero(
        tag: 'newHomeInspectionButton',
        child: ElevatedButton(
          onPressed: () {
            homeInspectionProvider.setDatetime(DateTime.now());
            homeInspectionProvider
                .setPosition(locationProvider.currentPosition);
            homeInspectionProvider.setAddress(locationProvider.currentAddress);
            Navigator.pushNamed(context, '/create-home-inspection');
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(1),
            fixedSize: MaterialStateProperty.all<Size>(const Size(220, 70)),
          ),
          child: const Text(
            'Nueva inspección de vivienda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class NewVectorRecordButton extends StatelessWidget {
  const NewVectorRecordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Hero(
        tag: 'newVectorRecordButton',
        child: ElevatedButton(
          onPressed: () {
            vectorRecordProvider.setDatetime(DateTime.now());
            vectorRecordProvider.setPosition(locationProvider.currentPosition);
            vectorRecordProvider.setAddress(locationProvider.currentAddress);
            Navigator.pushNamed(context, '/create-vector-record');
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(1),
            fixedSize: MaterialStateProperty.all<Size>(const Size(220, 70)),
          ),
          child: const Text(
            'Nuevo registro del vector',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
