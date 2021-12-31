import 'dart:async';
import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';
import 'package:deteccion_zonas_dengue/sources/providers/mosquito_point_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportAreaComment extends StatefulWidget {
  const ReportAreaComment({Key? key}) : super(key: key);

  @override
  _ReportAreaCommentState createState() => _ReportAreaCommentState();
}

class _ReportAreaCommentState extends State<ReportAreaComment> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _textController = TextEditingController();

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
    final LatLng point = ModalRoute.of(context)!.settings.arguments as LatLng;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff2c5364),
        elevation: 3.0,
        title: const Center(
          child: Text(
            'Agregar zona',
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
              height:_size.width * 0.05,
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
                    markerId: const MarkerId('main_point'),
                    position: point,
                    icon: markerIcon,
                    anchor: const Offset(0.5, 0.5),
                  )},
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle('[{"featureType": "poi","stylers": [{"visibility": "off"}]}]');
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: point,
                    zoom: 17,
                  ),
                ),
              ),
            ),

            SizedBox(
              height:_size.width * 0.08,
            ),

            Center(
              child: SizedBox(
                width: _size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Comentario',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff2c5364),
                      ),
                    ),

                    SizedBox(
                      height: _size.height * 0.02,
                    ),

                    TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: 'Insertar comentario',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xff2c5364), width: 2)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Color(0xff2c5364), width: 2)
                        ),
                      ),
                    ),

                    SizedBox(
                      height: _size.height * 0.02,
                    ),

                    ElevatedButton(
                      child: const Center(
                        child: Text(
                          'Enviar reporte',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(3.0),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff2c5364)),
                        minimumSize: MaterialStateProperty.all<Size>(Size(_size.width * 0.5, _size.height * 0.05)),
                      ),
                      onPressed: () {
                        _sendNewPoint(point, _textController.text);
                      }
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

  void _sendNewPoint(LatLng latLng, String comment) async {
    MosquitoPointModel mosquitoPoint = MosquitoPointModel(
      latitud: latLng.latitude,
      longitud: latLng.longitude,
      comentario: comment
    );

    MosquitoPointProvider mosquitoPointProvider = MosquitoPointProvider();
    bool response = await mosquitoPointProvider.createMosquitoPoint(mosquitoPoint);

    if (response) {
      showDialogCreatePoint(true);
    } else {
      showDialogCreatePoint(false);
    }
  }

  Future<dynamic> showDialogCreatePoint(bool success) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            elevation: 3,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            title: Center(
              child: Text(
                success ? 'Éxito' : 'Error',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xff2c5364),
                ),
              ),
            ),
            content: Text(success
              ? 'La zona ha sido guardada correctamente en la base de datos'
              : 'Verifica tu conexión a internet e intenta crear el punto nuevamente',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xff2c5364),
                  ),
                ),
                onPressed: () => success
                  ? Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false)
                  : Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    );
  }
}

