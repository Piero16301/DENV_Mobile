import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportAreaPage extends StatefulWidget {
  const ReportAreaPage({Key? key}) : super(key: key);

  @override
  _ReportAreaPageState createState() => _ReportAreaPageState();
}

class _ReportAreaPageState extends State<ReportAreaPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  MapType mapType = MapType.normal;
  int _markerIdCounter = 0;
  LatLng currentPosition = const LatLng(-12.135163895120733, -77.02331503157205);

  static const CameraPosition initialPoint = CameraPosition(
    target: LatLng(-12.135163895120733, -77.02331503157205),
    zoom: 17,
  );

  @override
  void initState() {
    super.initState();

    setMarker();
  }

  void setMarker() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_point.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,

          mapType: mapType,
          markers: Set<Marker>.of(_markers.values),
          onMapCreated: _onMapCreated,
          initialCameraPosition: initialPoint,
          onCameraMove: (CameraPosition position) {
            if (_markers.isNotEmpty) {
              MarkerId markerId = MarkerId(_markerIdVal());
              Marker marker = _markers[markerId]!;
              currentPosition = position.target;
              Marker updatedMarker = marker.copyWith(
                positionParam: position.target,
                iconParam: markerIcon,
                anchorParam: const Offset(0.5, 0.5),
              );

              setState(() {
                _markers[markerId] = updatedMarker;
              });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'Agregar zona'
        ),
        icon: const Icon(Icons.add_location_alt_rounded),
        backgroundColor: const Color(0xff2c5364),
        onPressed: () => Navigator.pushNamed(context, 'report_area_comment', arguments: currentPosition),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);

    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = initialPoint.target;
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
      icon: markerIcon,
      anchor: const Offset(0.5, 0.5),
    );

    setState(() {
      _markers[markerId] = marker;
    });
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }
}
