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
    return InkWell(
      // onTap: _loading
      //     ? null
      //     : () {
      //         setState(() {
      //           _loading = true;
      //         });
      //         Future.delayed(const Duration(seconds: 3), () {
      //           setState(() {
      //             _loading = false;
      //           });
      //         });
      //       },
      onTap: () => Navigator.pushNamed(context, '/map'),
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
                const AnimatedOpacity(
                  // opacity: _loading ? 1.0 : 0.0,
                  opacity: 0.0,
                  duration: Duration(milliseconds: 500),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 7,
                    ),
                  ),
                ),
              ],
            ),
            const AnimatedOpacity(
              // opacity: _loading ? 0.0 : 1.0,
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
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
        onPressed: () => Navigator.pushNamed(
          context,
          '/create_propagation_zone',
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(1),
          fixedSize: MaterialStateProperty.all<Size>(
            const Size(220, 70),
          ),
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
    );
  }
}
