import 'dart:async';
import 'package:deteccion_zonas_dengue/sources/models/mosquito_photo_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MosquitoPhotoView extends StatefulWidget {
  const MosquitoPhotoView({Key? key}) : super(key: key);

  @override
  _MosquitoPhotoViewState createState() => _MosquitoPhotoViewState();
}

class _MosquitoPhotoViewState extends State<MosquitoPhotoView> {
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  MapType mapType = MapType.normal;

  @override
  void initState() {
    super.initState();

    setMarker();
  }

  void setMarker() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_photo.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final MosquitoPhotoModel mosquitoPhotoModel = ModalRoute.of(context)!.settings.arguments as MosquitoPhotoModel;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff2c5364),
          elevation: 3.0,
          title: const Center(
            child: Text(
              'Foto con mosquitos',
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
              height: _size.width * 0.025,
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
                    markerId: MarkerId(mosquitoPhotoModel.id),
                    position: LatLng(mosquitoPhotoModel.latitud, mosquitoPhotoModel.longitud),
                    icon: markerIcon,
                    anchor: const Offset(0.5, 0.5),
                  )},
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle('[{"featureType": "poi","stylers": [{"visibility": "off"}]}]');
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(mosquitoPhotoModel.latitud, mosquitoPhotoModel.longitud),
                    zoom: 17,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: _size.width * 0.05,
            ),

            const Center(
              child: Text(
                'Fotografía',
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

            Center(
              child: Container(
                height: _size.height * 0.45,
                width: _size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xff2c5364),
                    width: 3,
                  ),
                ),
                child: FadeInImage(
                  image: NetworkImage(mosquitoPhotoModel.fotoUrl),
                  placeholder: const AssetImage('assets/image_loading.gif'),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(
              height: _size.width * 0.05,
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
              height: _size.width * 0.025,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                rowDetails(
                  _size,
                  Icons.location_on_outlined,
                  mosquitoPhotoModel.direccion,
                ),

                SizedBox(
                  height: _size.width * 0.05,
                ),

                rowDetails(
                  _size,
                  Icons.calendar_today_outlined,
                  mosquitoPhotoModel.fecha,
                ),

                SizedBox(
                  height: _size.width * 0.05,
                ),

                rowDetails(
                  _size,
                  Icons.access_time_outlined,
                  mosquitoPhotoModel.hora,
                ),
              ],
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

