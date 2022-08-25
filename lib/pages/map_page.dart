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

  BitmapDescriptor? _markerIconCaseReportLight;
  BitmapDescriptor? _markerIconPropagationZoneLight;
  BitmapDescriptor? _markerIconCaseReportDark;
  BitmapDescriptor? _markerIconPropagationZoneDark;

  // final MapType _currentMapType = MapType.normal;

  final Set<Marker> _markers = <Marker>{};
  final Set<Marker> _markersLight = <Marker>{};
  final Set<Marker> _markersDark = <Marker>{};

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

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    if (theme == Brightness.dark) {
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
    _createCustomMarker(context);

    _addMarkers();

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
            if (WidgetsBinding.instance.window.platformBrightness ==
                Brightness.dark) {
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

  Future<void> _createCustomMarker(BuildContext context) async {
    final ImageConfiguration imageConfiguration = createLocalImageConfiguration(
      context,
      size: const Size.square(200),
    );

    // Select the appropriate image based on the screen size
    double screenWidth = MediaQuery.of(context).size.width;
    String folderName = '';
    if (screenWidth < 750) {
      folderName = 'markers_720p';
      debugPrint('screenWidth < 750 $screenWidth');
    } else if (screenWidth < 1100) {
      folderName = 'markers_1080p';
      debugPrint('screenWidth < 1100 $screenWidth');
    } else {
      folderName = 'markers_1440p';
      debugPrint('screenWidth >= 1100 $screenWidth');
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

  void _addMarkers() {
    if (_markerIconCaseReportLight != null &&
        _markerIconPropagationZoneLight != null &&
        _markerIconCaseReportDark != null &&
        _markerIconPropagationZoneDark != null) {
      _markersLight.add(
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(-12.135211981936047, -77.03213588952726),
          anchor: const Offset(0.5, 0.5),
          icon: _markerIconCaseReportLight!,
        ),
      );
      _markersLight.add(
        Marker(
          markerId: const MarkerId('2'),
          position: const LatLng(-12.135211981936047, -77.02213588952726),
          anchor: const Offset(0.5, 0.5),
          icon: _markerIconPropagationZoneLight!,
        ),
      );

      _markersDark.add(
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(-12.135211981936047, -77.03213588952726),
          anchor: const Offset(0.5, 0.5),
          icon: _markerIconCaseReportDark!,
        ),
      );
      _markersDark.add(
        Marker(
          markerId: const MarkerId('2'),
          position: const LatLng(-12.135211981936047, -77.02213588952726),
          anchor: const Offset(0.5, 0.5),
          icon: _markerIconPropagationZoneDark!,
        ),
      );
    }
  }
}
