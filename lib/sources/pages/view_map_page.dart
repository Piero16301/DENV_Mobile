import 'dart:async';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';
import 'package:deteccion_zonas_dengue/sources/providers/mosquito_point_provider.dart';
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

  // Lista de todos los puntos de la base de datos
  List<MosquitoPointModel> points = [];

  @override
  void initState() {
    super.initState();

    getAllPoints();

    setMarker();
  }

  void getAllPoints() async {
    // Obtener todos los puntos de la base de datos
    MosquitoPointProvider mosquitoPointProvider = MosquitoPointProvider();
    List<MosquitoPointModel> response = await mosquitoPointProvider.getAllMosquitoPoints();
    points = List.from(response);
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

    for (var element in points) {
      markers.add(Marker(
        markerId: MarkerId(element.id),
        icon: markerIcon,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(element.latitud, element.longitud),
        infoWindow: InfoWindow(
          title: 'Mosquitos',
          snippet: element.comentario,
        ),
      ));
    }

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