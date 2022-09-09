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

  BitmapDescriptor? _markerIconHomeInspectionLight;
  BitmapDescriptor? _markerIconVectorRecordLight;
  BitmapDescriptor? _markerIconHomeInspectionDark;
  BitmapDescriptor? _markerIconVectorRecordDark;

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

    final homeInspectionsSummarized = Provider.of<MapProvider>(
      context,
      listen: false,
    ).homeInspectionsSummarized;
    final vectorRecordsSummarized = Provider.of<MapProvider>(
      context,
      listen: false,
    ).vectorRecordsSummarized;

    final locationProvider = Provider.of<LocationProvider>(context);
    final mapService = Provider.of<MapService>(context);

    if (!_centerSet) {
      _calculateCenter(
        homeInspectionsSummarized,
        vectorRecordsSummarized,
        locationProvider.currentPosition!,
      );
      _centerSet = true;
    }

    _addAllMarkers(
      homeInspectionsSummarized,
      vectorRecordsSummarized,
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

    if (_markerIconHomeInspectionLight == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_case_report_light.png',
      ).then(_updateBitmapHomeInspectionLight);
    }

    if (_markerIconVectorRecordLight == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_propagation_zone_light.png',
      ).then(_updateBitmapVectorRecordLight);
    }

    if (_markerIconHomeInspectionDark == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_case_report_dark.png',
      ).then(_updateBitmapHomeInspectionDark);
    }

    if (_markerIconVectorRecordDark == null) {
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/$folderName/marker_propagation_zone_dark.png',
      ).then(_updateBitmapVectorRecordDark);
    }
  }

  void _updateBitmapHomeInspectionLight(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconHomeInspectionLight = bitmap;
    });
  }

  void _updateBitmapVectorRecordLight(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconVectorRecordLight = bitmap;
    });
  }

  void _updateBitmapHomeInspectionDark(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconHomeInspectionDark = bitmap;
    });
  }

  void _updateBitmapVectorRecordDark(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconVectorRecordDark = bitmap;
    });
  }

  void _calculateCenter(
    List<HomeInspectionSummarizedModel> homeInspectionsSummarized,
    List<VectorRecordSummarizedModel> vectorRecordsSummarized,
    Position currentPosition,
  ) {
    debugPrint('Calculating center');
    double avgLatCases = homeInspectionsSummarized.isEmpty
        ? 0.0
        : homeInspectionsSummarized
                .map((e) => e.latitude)
                .reduce((value, element) => value + element) /
            homeInspectionsSummarized.length;
    double avgLonCases = homeInspectionsSummarized.isEmpty
        ? 0.0
        : homeInspectionsSummarized
                .map((e) => e.longitude)
                .reduce((value, element) => value + element) /
            homeInspectionsSummarized.length;

    double avgLatZones = vectorRecordsSummarized.isEmpty
        ? 0.0
        : vectorRecordsSummarized
                .map((e) => e.latitude)
                .reduce((value, element) => value + element) /
            vectorRecordsSummarized.length;
    double avgLonZones = vectorRecordsSummarized.isEmpty
        ? 0.0
        : vectorRecordsSummarized
                .map((e) => e.longitude)
                .reduce((value, element) => value + element) /
            vectorRecordsSummarized.length;

    int totalRegisters =
        homeInspectionsSummarized.length + vectorRecordsSummarized.length;
    double avgLat = totalRegisters == 0
        ? currentPosition.latitude
        : (avgLatCases * (homeInspectionsSummarized.length / totalRegisters)) +
            (avgLatZones * (vectorRecordsSummarized.length / totalRegisters));
    double avgLon = totalRegisters == 0
        ? currentPosition.longitude
        : (avgLonCases * (homeInspectionsSummarized.length / totalRegisters)) +
            (avgLonZones * (vectorRecordsSummarized.length / totalRegisters));

    setState(() {
      _center = LatLng(avgLat, avgLon);
    });
  }

  void _addAllMarkers(
    List<HomeInspectionSummarizedModel> homeInspectionsSummarized,
    List<VectorRecordSummarizedModel> vectorRecordsSummarized,
    MapService mapService,
  ) {
    if (_markerIconHomeInspectionLight != null &&
        _markerIconVectorRecordLight != null &&
        _markerIconHomeInspectionDark != null &&
        _markerIconVectorRecordDark != null) {
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
      if (homeInspectionsSummarized.isNotEmpty) {
        for (var homeInspection in homeInspectionsSummarized) {
          _markersLight.add(
            Marker(
              markerId: MarkerId(homeInspection.id),
              position: LatLng(
                homeInspection.latitude,
                homeInspection.longitude,
              ),
              icon: _markerIconHomeInspectionLight!,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de este caso',
                onTap: () =>
                    _getHomeInspectionDetails(homeInspection, mapService),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToHomeInspection(homeInspection),
            ),
          );
          _markersDark.add(
            Marker(
              markerId: MarkerId(homeInspection.id),
              position: LatLng(
                homeInspection.latitude,
                homeInspection.longitude,
              ),
              icon: _markerIconHomeInspectionDark!,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de este caso',
                onTap: () =>
                    _getHomeInspectionDetails(homeInspection, mapService),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToHomeInspection(homeInspection),
            ),
          );
        }
      }

      // Add markers for propagation zones to light and dark list
      if (vectorRecordsSummarized.isNotEmpty) {
        for (var vectorRecord in vectorRecordsSummarized) {
          _markersLight.add(
            Marker(
              markerId: MarkerId(vectorRecord.id),
              position: LatLng(
                vectorRecord.latitude,
                vectorRecord.longitude,
              ),
              icon: _markerIconVectorRecordLight!,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de esta zona',
                onTap: () => _getVectorRecordDetails(
                  vectorRecord,
                  mapService,
                ),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToVectorRecord(vectorRecord),
            ),
          );
        }
        for (var vectorRecord in vectorRecordsSummarized) {
          _markersDark.add(
            Marker(
              markerId: MarkerId(vectorRecord.id),
              position: LatLng(
                vectorRecord.latitude,
                vectorRecord.longitude,
              ),
              icon: _markerIconVectorRecordDark!,
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(
                title: 'Mostrar detalles',
                snippet: 'Presiona para ver detalles de esta zona',
                onTap: () => _getVectorRecordDetails(
                  vectorRecord,
                  mapService,
                ),
              ),
              // Zoom in on marker when tapped
              onTap: () => _focusCameraToVectorRecord(vectorRecord),
            ),
          );
        }
      }
    }
  }

  void _getHomeInspectionDetails(
    HomeInspectionSummarizedModel homeInspectionSummarized,
    MapService mapService,
  ) async {
    // Get case report details
    HomeInspectionModel? homeInspectionModel =
        await mapService.getHomeInspection(homeInspectionSummarized.id);
    // Show case report details
    if (homeInspectionModel != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        '/home-inspection',
        arguments: homeInspectionModel,
      );
    }
  }

  void _getVectorRecordDetails(
    VectorRecordSummarizedModel vectorRecordSummarized,
    MapService mapService,
  ) async {
    // Get propagation zone details
    VectorRecordModel? vectorRecordModel =
        await mapService.getVectorRecord(vectorRecordSummarized.id);
    if (vectorRecordModel != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        '/vector-record',
        arguments: vectorRecordModel,
      );
    }
  }

  void _focusCameraToHomeInspection(
    HomeInspectionSummarizedModel homeInspectionSummarizedModel,
  ) {
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          homeInspectionSummarizedModel.latitude,
          homeInspectionSummarizedModel.longitude,
        ),
        17,
      ),
    );
  }

  void _focusCameraToVectorRecord(
    VectorRecordSummarizedModel vectorRecordSummarizedModel,
  ) {
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          vectorRecordSummarizedModel.latitude,
          vectorRecordSummarizedModel.longitude,
        ),
        17,
      ),
    );
  }
}
