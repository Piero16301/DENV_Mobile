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
                      NewCaseReportButton(),
                      NewPropagationZoneButton(),
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
      onTap: mapService.isGettingCaseReports ||
              mapService.isGettingPropagationZones
          ? null
          : () async {
              final caseReportsSummarized =
                  await mapService.getCaseReportsSummarized();
              final propagationZonesSummarized =
                  await mapService.getPropagationZonesSummarized();

              mapProvider.setCaseReportsSummarized(caseReportsSummarized);
              mapProvider
                  .setPropagationZonesSummarized(propagationZonesSummarized);

              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/map');
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
                  opacity: mapService.isGettingCaseReports ||
                          mapService.isGettingPropagationZones
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
              opacity: mapService.isGettingCaseReports ||
                      mapService.isGettingPropagationZones
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
}

class NewCaseReportButton extends StatelessWidget {
  const NewCaseReportButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Hero(
        tag: 'newCaseReportButton',
        child: ElevatedButton(
          onPressed: () {
            caseReportProvider.setDatetime(DateTime.now());
            caseReportProvider.setPosition(locationProvider.currentPosition);
            caseReportProvider.setAddress(locationProvider.currentAddress);
            Navigator.pushNamed(context, '/create_case_report');
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(1),
            fixedSize: MaterialStateProperty.all<Size>(const Size(220, 70)),
          ),
          child: const Text(
            'Reportar nuevo caso de dengue',
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

class NewPropagationZoneButton extends StatelessWidget {
  const NewPropagationZoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final propagationZoneProvider =
        Provider.of<PropagationZoneProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Hero(
        tag: 'newPropagationZoneButton',
        child: ElevatedButton(
          onPressed: () {
            propagationZoneProvider.setDatetime(DateTime.now());
            propagationZoneProvider
                .setPosition(locationProvider.currentPosition);
            propagationZoneProvider.setAddress(locationProvider.currentAddress);
            Navigator.pushNamed(context, '/create_propagation_zone');
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(1),
            fixedSize: MaterialStateProperty.all<Size>(const Size(220, 70)),
          ),
          child: const Text(
            'Reportar nueva zona de propagación',
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
