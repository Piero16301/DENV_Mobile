import 'dart:async';

import 'package:denv_mobile/models/models.dart';
import 'package:denv_mobile/providers/providers.dart';
import 'package:denv_mobile/services/map_service.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;

  String _darkMapStyle = '';
  String _lightMapStyle = '';

  BitmapDescriptor? _markerIconCaseReportLight;
  BitmapDescriptor? _markerIconPropagationZoneLight;
  BitmapDescriptor? _markerIconCaseReportDark;
  BitmapDescriptor? _markerIconPropagationZoneDark;

  final Set<Marker> _markers = <Marker>{};
  final Set<Marker> _markersLight = <Marker>{};
  final Set<Marker> _markersDark = <Marker>{};
  bool _markersLoaded = false;

  LatLng _center = const LatLng(0, 0);
  bool _centerSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    ThemeModeApp.changeTheme(!ThemeModeApp.isDarkMode);
    setState(() {
      _setMapStyle();
    });
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    if (ThemeModeApp.isDarkMode) {
      setState(() {
        controller.setMapStyle(_darkMapStyle);
        _markers.clear();
        _markers.addAll(_markersDark);
      });
    } else {
      setState(() {
        controller.setMapStyle(_lightMapStyle);
        _markers.clear();
        _markers.addAll(_markersLight);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _createCustomMarker(MediaQuery.of(context));

    final caseReportsSummarized = Provider.of<MapProvider>(
      context,
      listen: false,
    ).caseReportsSummarized;
    final propagationZonesSummarized = Provider.of<MapProvider>(
      context,
      listen: false,
    ).propagationZonesSummarized;

    final locationProvider = Provider.of<LocationProvider>(context);
    final mapService = Provider.of<MapService>(context);

    if (!_centerSet) {
      _calculateCenter(
        caseReportsSummarized,
        propagationZonesSummarized,
        locationProvider.currentPosition!,
      );
      _centerSet = true;
    }

    _addAllMarkers(
      caseReportsSummarized,
      propagationZonesSummarized,
      mapService,
    );

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13,
          ),
          buildingsEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          indoorViewEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          tiltGesturesEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
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
      folderName = 'markers_720p';
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

  void _calculateCenter(
    List<CaseReportSummarizedModel> caseReportsSummarized,
    List<PropagationZoneSummarizedModel> propagationZonesSummarized,
    Position currentPosition,
  ) {
    debugPrint('Calculating center');
    double avgLatCases = caseReportsSummarized.isEmpty
        ? 0.0
        : caseReportsSummarized
                .map((e) => e.latitude)
                .reduce((value, element) => value + element) /
            caseReportsSummarized.length;
    double avgLonCases = caseReportsSummarized.isEmpty
        ? 0.0
        : caseReportsSummarized
                .map((e) => e.longitude)
                .reduce((value, element) => value + element) /
            caseReportsSummarized.length;

    double avgLatZones = propagationZonesSummarized.isEmpty
        ? 0.0
        : propagationZonesSummarized
                .map((e) => e.latitude)
                .reduce((value, element) => value + element) /
            propagationZonesSummarized.length;
    double avgLonZones = propagationZonesSummarized.isEmpty
        ? 0.0
        : propagationZonesSummarized
                .map((e) => e.longitude)
                .reduce((value, element) => value + element) /
            propagationZonesSummarized.length;

    int totalRegisters =
        caseReportsSummarized.length + propagationZonesSummarized.length;
    double avgLat = totalRegisters == 0
        ? currentPosition.latitude
        : (avgLatCases * (caseReportsSummarized.length / totalRegisters)) +
            (avgLatZones *
                (propagationZonesSummarized.length / totalRegisters));
    double avgLon = totalRegisters == 0
        ? currentPosition.longitude
        : (avgLonCases * (caseReportsSummarized.length / totalRegisters)) +
            (avgLonZones *
                (propagationZonesSummarized.length / totalRegisters));

    setState(() {
      _center = LatLng(avgLat, avgLon);
    });
  }

  void _addAllMarkers(
    List<CaseReportSummarizedModel> caseReportsSummarized,
    List<PropagationZoneSummarizedModel> propagationZonesSummarized,
    MapService mapService,
  ) {
    if (_markerIconCaseReportLight != null &&
        _markerIconPropagationZoneLight != null &&
        _markerIconCaseReportDark != null &&
        _markerIconPropagationZoneDark != null) {
      if (_markersLoaded) {
        return;
      }
      setState(() {
        _markersLoaded = true;
      });

      debugPrint('Adding all markers');

      // Clear current lists
      _markersLight.clear();
      _markersDark.clear();

      // Add markers for case reports to light and dark list
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
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de este caso',
                onTap: () => _getCaseReportDetails(caseReport, mapService),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToCaseReport(caseReport),
            ),
          );
          _markersDark.add(
            Marker(
              markerId: MarkerId(caseReport.id),
              position: LatLng(
                caseReport.latitude,
                caseReport.longitude,
              ),
              icon: _markerIconCaseReportDark!,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de este caso',
                onTap: () => _getCaseReportDetails(caseReport, mapService),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToCaseReport(caseReport),
            ),
          );
        }
      }

      // Add markers for propagation zones to light and dark list
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
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de esta zona',
                onTap: () => _getPropagationZoneDetails(
                  propagationZone,
                  mapService,
                ),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToPropagationZone(propagationZone),
            ),
          );
        }
        for (var propagationZone in propagationZonesSummarized) {
          _markersDark.add(
            Marker(
              markerId: MarkerId(propagationZone.id),
              position: LatLng(
                propagationZone.latitude,
                propagationZone.longitude,
              ),
              icon: _markerIconPropagationZoneDark!,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de esta zona',
                onTap: () => _getPropagationZoneDetails(
                  propagationZone,
                  mapService,
                ),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToPropagationZone(propagationZone),
            ),
          );
        }
      }
    }
  }

  void _getCaseReportDetails(
    CaseReportSummarizedModel caseReportSummarized,
    MapService mapService,
  ) async {
    // Get case report details
    CaseReportModel? caseReportModel =
        await mapService.getCaseReport(caseReportSummarized.id);
    // Show case report details
    if (caseReportModel != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        '/case-report',
        arguments: caseReportModel,
      );
    }
  }

  void _getPropagationZoneDetails(
    PropagationZoneSummarizedModel propagationZoneSummarized,
    MapService mapService,
  ) async {
    // Get propagation zone details
    PropagationZoneModel? propagationZoneModel =
        await mapService.getPropagationZone(propagationZoneSummarized.id);
    if (propagationZoneModel != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        '/propagation-zone',
        arguments: propagationZoneModel,
      );
    }
  }

  void _focusCameraToCaseReport(
    CaseReportSummarizedModel caseReportSummarizedModel,
  ) {
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          caseReportSummarizedModel.latitude,
          caseReportSummarizedModel.longitude,
        ),
        17,
      ),
    );
  }

  void _focusCameraToPropagationZone(
    PropagationZoneSummarizedModel propagationZoneSummarizedModel,
  ) {
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          propagationZoneSummarizedModel.latitude,
          propagationZoneSummarizedModel.longitude,
        ),
        17,
      ),
    );
  }
}
