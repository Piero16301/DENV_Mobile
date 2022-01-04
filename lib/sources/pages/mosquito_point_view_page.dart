import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';

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
    markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_point.png');
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
          ),
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
              height: _size.height * 0.025,
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

                  // Para ocultar los botones de direcciones
                  mapToolbarEnabled: false,

                  mapType: mapType,
                  markers: <Marker>{Marker(
                    markerId: MarkerId(mosquitoPointModel.id),
                    position: LatLng(mosquitoPointModel.latitud, mosquitoPointModel.longitud),
                    icon: markerIcon,
                    anchor: const Offset(0.5, 0.5),
                  )},
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle('[{"featureType": "poi","stylers": [{"visibility": "off"}]}]');
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
              height: _size.width * 0.05,
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
                      height: _size.width * 0.025,
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
              height:_size.width * 0.05,
            ),

            const Center(
              child: Text(
                'Detalles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff2c5364),
                ),
              ),
            ),

            SizedBox(
              height:_size.width * 0.05,
            ),

            rowDetails(
              _size,
              Icons.location_on_outlined,
              mosquitoPointModel.direccion,
            ),

            SizedBox(
              height:_size.width * 0.05,
            ),

            rowDetails(
              _size,
              Icons.calendar_today_outlined,
              mosquitoPointModel.fecha,
            ),

            SizedBox(
              height:_size.width * 0.05,
            ),

            rowDetails(
              _size,
              Icons.access_time_outlined,
              mosquitoPointModel.hora,
            ),

            SizedBox(
              height: _size.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Row rowDetails(Size _size, IconData iconData, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: _size.width * 0.05,
        ),

        Icon(
          iconData,
          color: Colors.black,
          size: 30,
        ),

        SizedBox(
          width: _size.width * 0.05,
        ),

        SizedBox(
          width: _size.width * 0.65,
          child: Text(
            text,
            overflow: TextOverflow.clip,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}

