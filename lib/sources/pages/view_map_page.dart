import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';
import 'package:deteccion_zonas_dengue/sources/models/mosquito_photo_model.dart';
import 'package:deteccion_zonas_dengue/sources/models/screen_arguments_model.dart';

class ViewMapPage extends StatefulWidget {
  const ViewMapPage({Key? key}) : super(key: key);

  @override
  _ViewMapPageState createState() => _ViewMapPageState();
}

class _ViewMapPageState extends State<ViewMapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor markerIconPoint = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconPhoto = BitmapDescriptor.defaultMarker;

  MapType mapType = MapType.normal;

  // Conjunto de todos los marcadores
  Set<Marker> markers = <Marker>{};

  @override
  void initState() {
    super.initState();

    setMarkers();
  }

  void setMarkers() async {
    markerIconPoint = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_point.png');
    markerIconPhoto = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_photo.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Recibir el objeto del HomePage
    final ScreenArguments screenArguments = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    // Posición inicial de la cámara
    LatLng initialPosition = LatLng(screenArguments.centerLatitude, screenArguments.centerLongitude);

    // Recibir data y agregar marcadores
    addAllPoints(screenArguments.listMosquitoPoints);
    addAllPhotos(screenArguments.listMosquitoPhotos);

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,

          // Para ocultar los botones de direcciones
          mapToolbarEnabled: false,

          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: mapType,
          markers: markers,
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 12,
          ),
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle('[{"featureType": "poi","stylers": [{"visibility": "off"}]}]');
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  void addAllPoints(List<MosquitoPointModel> points) {
    // Se agregan los puntos a los marcadores
    for (var point in points) {
      markers.add(Marker(
        markerId: MarkerId(point.id),
        icon: markerIconPoint,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(
          title: 'Área con mosquitos',
          onTap: () => Navigator.pushNamed(context, 'mosquito_point_view', arguments: point),
        ),
      ));
    }
  }

  void addAllPhotos(List<MosquitoPhotoModel> photos) {
    // Se agregan las fotos a los marcadores
    for (var photo in photos) {
      markers.add(Marker(
        markerId: MarkerId(photo.id),
        icon: markerIconPhoto,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(photo.latitude, photo.longitude),
        infoWindow: InfoWindow(
          title: 'Foto de mosquitos',
          onTap: () => Navigator.pushNamed(context, 'mosquito_photo_view', arguments: photo),
        ),
      ));
    }
  }
}
