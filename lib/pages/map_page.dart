import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();

  String _darkMapStyle = '';
  String _lightMapStyle = '';

  BitmapDescriptor _markerIconCaseReportLight = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _markerIconPropagationZoneLight =
      BitmapDescriptor.defaultMarker;
  BitmapDescriptor _markerIconCaseReportDark = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _markerIconPropagationZoneDark =
      BitmapDescriptor.defaultMarker;

  // final MapType _currentMapType = MapType.normal;

  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    _setCustomMapPin();

    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    if (theme == Brightness.dark) {
      controller.setMapStyle(_darkMapStyle);
    } else {
      controller.setMapStyle(_lightMapStyle);
    }
  }

  void _setCustomMapPin() async {
    _markerIconCaseReportLight = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/markers_small/marker_case_report_light.png',
    );
    _markerIconPropagationZoneLight = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/markers_small/marker_propagation_zone_light.png',
    );

    _markerIconCaseReportDark = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/markers_small/marker_case_report_dark.png',
    );
    _markerIconPropagationZoneDark = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/markers_small/marker_propagation_zone_dark.png',
    );
    setState(() {});
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {
      _setMapStyle();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    addMarkers();

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-12.135211981936047, -77.02213588952726),
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _setMapStyle();
          },
          markers: _markers,
        ),
      ),
    );
  }

  void addMarkers() {
    if (_markerIconCaseReportLight != BitmapDescriptor.defaultMarker &&
        _markerIconPropagationZoneLight != BitmapDescriptor.defaultMarker) {
      _markers.add(
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(-12.135211981936047, -77.03213588952726),
          anchor: const Offset(0.5, 0.5),
          icon: _markerIconCaseReportLight,
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('2'),
          position: const LatLng(-12.135211981936047, -77.02213588952726),
          anchor: const Offset(0.5, 0.5),
          icon: _markerIconPropagationZoneLight,
        ),
      );
    }
  }
}
