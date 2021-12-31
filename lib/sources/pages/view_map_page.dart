import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';
import 'package:deteccion_zonas_dengue/sources/providers/mosquito_point_provider.dart';
import 'package:deteccion_zonas_dengue/sources/models/mosquito_photo_model.dart';
import 'package:deteccion_zonas_dengue/sources/providers/mosquito_photo_provider.dart';

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

  // Posición inicial de la cámara
  LatLng initialPosition = const LatLng(-12.135525263353959, -77.02378141325494);

  // Conjunto de todos los marcadores
  Set<Marker> markers = <Marker>{};

  // Lista de todos los puntos de la base de datos
  List<MosquitoPointModel> points = [];

  // Lista de todas las fotos de la base de datos
  List<MosquitoPhotoModel> photos = [];

  @override
  void initState() {
    super.initState();

    setMarkers();

    // Obtener información de la base de datos
    getAllPoints();
    getAllPhotos();
  }

  void setMarkers() async {
    markerIconPoint = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_point.png');
    markerIconPhoto = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_photo.png');
    setState(() {});
  }

  // Llamar marcadores de puntos desde base de datos
  void getAllPoints() async {
    // Obtener todos los puntos de la base de datos
    MosquitoPointProvider mosquitoPointProvider = MosquitoPointProvider();
    List<MosquitoPointModel> response = await mosquitoPointProvider.getAllMosquitoPoints();
    points = List.from(response);

    setState(() {});
  }

  // Llamar marcadores de fotos desde base de datos
  void getAllPhotos() async {
    // Obtener todos las fotos de la base de datos
    MosquitoPhotoProvider mosquitoPhotoProvider = MosquitoPhotoProvider();
    List<MosquitoPhotoModel> response = await mosquitoPhotoProvider.getAllMosquitoPhotos();
    photos = List.from(response);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Agregar información al conjunto de marcadores
    addAllPoints();
    addAllPhotos();

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
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle('[{"featureType": "poi","stylers": [{"visibility": "off"}]}]');
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  void addAllPoints() {
    // Se agregan los puntos a los marcadores
    for (var point in points) {
      markers.add(Marker(
        markerId: MarkerId(point.id),
        icon: markerIconPoint,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(point.latitud, point.longitud),
        infoWindow: InfoWindow(
          title: 'Área con mosquitos',
          onTap: () => Navigator.pushNamed(context, 'mosquito_point_view', arguments: point),
        ),
      ));
    }
  }

  void addAllPhotos() {
    // Se agregan las fotos a los marcadores
    for (var photo in photos) {
      markers.add(Marker(
        markerId: MarkerId(photo.id),
        icon: markerIconPhoto,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(photo.latitud, photo.longitud),
        infoWindow: InfoWindow(
          title: 'Foto de mosquitos',
          onTap: () => Navigator.pushNamed(context, 'mosquito_photo_view', arguments: photo),
        ),
      ));
    }
  }
}
