import 'dart:async';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MosquitoPointViewPage extends StatefulWidget {
  const MosquitoPointViewPage({Key? key}) : super(key: key);

  @override
  _MosquitoPointViewPageState createState() => _MosquitoPointViewPageState();
}

class _MosquitoPointViewPageState extends State<MosquitoPointViewPage> {
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
    final _size = MediaQuery.of(context).size;
    final MosquitoPointModel mosquitoPointModel = ModalRoute.of(context)!.settings.arguments as MosquitoPointModel;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff2c5364),
          elevation: 3.0,
          title: const Center(
            child: Text(
              'Área con mosquitos',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          )
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: _size.width * 0.05,
            ),

            const Center(
              child: Text(
                'Ubicación',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff2c5364),
                ),
              ),
            ),

            SizedBox(
              height: _size.height * 0.02,
            ),

            Center(
              child: SizedBox(
                height: _size.height * 0.45,
                width: _size.width * 0.9,
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,

                  // Gestos a bloquear para que no se mueva el mapa
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomGesturesEnabled: false,

                  mapType: mapType,
                  markers: <Marker>{Marker(
                    markerId: MarkerId(mosquitoPointModel.id),
                    position: LatLng(mosquitoPointModel.latitud, mosquitoPointModel.longitud),
                    icon: markerIcon,
                    anchor: const Offset(0.5, 0.5),
                  )},
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(mosquitoPointModel.latitud, mosquitoPointModel.longitud),
                    zoom: 17,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: _size.width * 0.08,
            ),

            Center(
              child: SizedBox(
                width: _size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Comentario',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xff2c5364),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: _size.height * 0.02,
                    ),

                    Container(
                      width: _size.width * 0.9,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff2c5364),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        mosquitoPointModel.comentario,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: _size.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}

