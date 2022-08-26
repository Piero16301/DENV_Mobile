import 'dart:async';

import 'package:denv_mobile/providers/providers.dart';
import 'package:denv_mobile/services/services.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();

  String _darkMapStyle = '';
  String _lightMapStyle = '';

  BitmapDescriptor? _markerIconCaseReportLight;
  BitmapDescriptor? _markerIconPropagationZoneLight;
  BitmapDescriptor? _markerIconCaseReportDark;
  BitmapDescriptor? _markerIconPropagationZoneDark;

  Timer? _timer;

  final Set<Marker> _markers = <Marker>{};
  final Set<Marker> _markersLight = <Marker>{};
  final Set<Marker> _markersDark = <Marker>{};

  bool _isFirtsLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      _createCustomMarker(MediaQuery.of(context));
    });
    _loadMapStyles();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        debugPrint('Agregando marcadores');
        if (_isFirtsLoad) {
          _isFirtsLoad = false;
          _addMarkers(Provider.of<MapProvider>(context, listen: false));
        } else {
          final mapService = Provider.of<MapService>(context, listen: false);
          final mapProvider = Provider.of<MapProvider>(context, listen: false);
          final caseReportsSummarized =
              await mapService.getCaseReportsSummarized();
          final propagationZonesSummarized =
              await mapService.getPropagationZonesSummarized();

          mapProvider.setCaseReportsSummarized(caseReportsSummarized);
          mapProvider.setPropagationZonesSummarized(propagationZonesSummarized);

          // ignore: use_build_context_synchronously
          _addMarkers(Provider.of<MapProvider>(context, listen: false));
        }
      });
    });
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {
      _setMapStyle();
    });
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    if (ThemeModeApp.isDarkMode) {
      controller.setMapStyle(_darkMapStyle);
      _markers.clear();
      _markers.addAll(_markersDark);
    } else {
      controller.setMapStyle(_lightMapStyle);
      _markers.clear();
      _markers.addAll(_markersLight);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-12.135211981936047, -77.02213588952726),
            zoom: 15,
          ),
          buildingsEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          indoorViewEnabled: true,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          tiltGesturesEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _setMapStyle();
            if (ThemeModeApp.isDarkMode) {
              _markers.addAll(_markersDark);
            } else {
              _markers.addAll(_markersLight);
            }
          },
          markers: _markers,
        ),
      ),
    );
  }

  Future<void> _createCustomMarker(MediaQueryData mediaQueryData) async {
    final ImageConfiguration imageConfiguration = createLocalImageConfiguration(
      context,
      size: const Size.square(200),
    );

    // Select the appropriate image based on the screen size
    double screenWidth =
        mediaQueryData.size.width * mediaQueryData.devicePixelRatio;
    double screenHeight =
        mediaQueryData.size.height * mediaQueryData.devicePixelRatio;
    String folderName = '';
    if (screenWidth < 750) {
      folderName = 'markers_720p';
      debugPrint('screenWidth < 750 $screenWidth $screenHeight');
    } else if (screenWidth >= 750 && screenWidth < 1100) {
      folderName = 'markers_1080p';
      debugPrint(
          'screenWidth >= 750 && screenWidth < 1100 $screenWidth $screenHeight');
    } else {
      folderName = 'markers_1440p';
      debugPrint('screenWidth >= 1100 $screenWidth $screenHeight');
    }

    if (_markerIconCaseReportLight == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_case_report_light.png',
      ).then(_updateBitmapCaseReportLight);
    }

    if (_markerIconPropagationZoneLight == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_propagation_zone_light.png',
      ).then(_updateBitmapPropagationZoneLight);
    }

    if (_markerIconCaseReportDark == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_case_report_dark.png',
      ).then(_updateBitmapCaseReportDark);
    }

    if (_markerIconPropagationZoneDark == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_propagation_zone_dark.png',
      ).then(_updateBitmapPropagationZoneDark);
    }
  }

  void _updateBitmapCaseReportLight(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconCaseReportLight = bitmap;
    });
  }

  void _updateBitmapPropagationZoneLight(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconPropagationZoneLight = bitmap;
    });
  }

  void _updateBitmapCaseReportDark(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconCaseReportDark = bitmap;
    });
  }

  void _updateBitmapPropagationZoneDark(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconPropagationZoneDark = bitmap;
    });
  }

  void _addMarkers(MapProvider mapProvider) {
    if (_markerIconCaseReportLight != null &&
        _markerIconPropagationZoneLight != null &&
        _markerIconCaseReportDark != null &&
        _markerIconPropagationZoneDark != null) {
      final caseReportsSummarized = mapProvider.caseReportsSummarized;
      final propagationZonesSummarized = mapProvider.propagationZonesSummarized;
      _markersLight.clear();
      _markersDark.clear();
      if (caseReportsSummarized.isNotEmpty) {
        for (var caseReport in caseReportsSummarized) {
          _markersLight.add(
            Marker(
              markerId: MarkerId(caseReport.id),
              position: LatLng(
                caseReport.latitude,
                caseReport.longitude,
              ),
              icon: _markerIconCaseReportLight!,
              onTap: () {
                // Navigator.pushNamed(context, '/case_report', arguments: {
                //   'caseReport': caseReport,
                // });
                debugPrint('caseReport ${caseReport.id}');
              },
            ),
          );
        }
      }
      if (propagationZonesSummarized.isNotEmpty) {
        for (var propagationZone in propagationZonesSummarized) {
          _markersLight.add(
            Marker(
              markerId: MarkerId(propagationZone.id),
              position: LatLng(
                propagationZone.latitude,
                propagationZone.longitude,
              ),
              icon: _markerIconPropagationZoneLight!,
              onTap: () {
                // Navigator.pushNamed(context, '/propagation_zone', arguments: {
                //   'propagationZone': propagationZone,
                // });
                debugPrint('propagationZone ${propagationZone.id}');
              },
            ),
          );
        }
      }
    }
  }
}
