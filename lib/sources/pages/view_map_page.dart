import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMapPage extends StatefulWidget {
  const ViewMapPage({Key? key}) : super(key: key);

  @override
  _ViewMapPageState createState() => _ViewMapPageState();
}

class _ViewMapPageState extends State<ViewMapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  MapType mapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    setMarker();
  }

  void setMarker() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const CameraPosition initialPoint = CameraPosition(
        target: LatLng(-12.135163895120733, -77.02331503157205),
        zoom: 17.5
    );

    // Llamar marcadores desde base de datos
    Set<Marker> markers = <Marker>{};

    markers.add(Marker(
      markerId: const MarkerId('-MYMR9IcLh9d5A2m4zbn'),
      icon: markerIcon,
      anchor: const Offset(0.5, 0.5),
      position: const LatLng(-12.135163895120733, -77.02331503157205),
      infoWindow: const InfoWindow(
        title: 'Mosquitos',
        snippet: 'Se han reportado mosquitos bastantes',
      ),
    ));

    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: mapType,
        markers: markers,
        initialCameraPosition: initialPoint,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
