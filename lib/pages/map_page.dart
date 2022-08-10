import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor _markerIconCaseReport = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _markerIconPropagationZone = BitmapDescriptor.defaultMarker;

  final MapType _currentMapType = MapType.normal;

  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    _setCustomMapPin();
  }

  void _setCustomMapPin() async {
    _markerIconCaseReport = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/markers/marker_case_report.png',
    );
    _markerIconPropagationZone = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/markers/marker_propagation_zone.png',
    );
    setState(() {});
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
            controller.setMapStyle(
              '[{"featureType": "poi","stylers": [{"visibility": "off"}]}]',
            );
            _controller.complete(controller);
          },
          markers: _markers,
        ),
      ),
    );
  }

  void addMarkers() {
    if (_markerIconCaseReport != BitmapDescriptor.defaultMarker &&
        _markerIconPropagationZone != BitmapDescriptor.defaultMarker) {
      _markers.add(
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(-12.135211981936047, -77.03213588952726),
          icon: _markerIconCaseReport,
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('2'),
          position: const LatLng(-12.135211981936047, -77.02213588952726),
          icon: _markerIconPropagationZone,
        ),
      );
    }
  }
}
