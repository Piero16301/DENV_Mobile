import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';
import 'package:deteccion_zonas_dengue/sources/providers/location_provider.dart';
import 'package:deteccion_zonas_dengue/sources/providers/mosquito_point_provider.dart';

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

  String currentAddress = '-';
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  bool firstCall = true;

  @override
  void initState() {
    super.initState();

    setMarker();

    // Inicializar el loader
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 50.0
      ..animationStyle = EasyLoadingAnimationStyle.scale
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.black;
  }

  void setMarker() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/map_marker_point.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final LatLng point = ModalRoute.of(context)!.settings.arguments as LatLng;
    final String _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final String _currentHour = DateFormat('Hms').format(DateTime.now());

    if (firstCall) {
      getAddress(latitude: point.latitude, longitude: point.longitude).then((
          address) {
        currentAddress = address;

        setState(() {});
      });
      firstCall = false;
    }

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
              height:_size.width * 0.05,
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
                      height: _size.width * 0.025,
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
                      currentAddress,
                    ),

                    SizedBox(
                      height:_size.width * 0.05,
                    ),

                    rowDetails(
                        _size,
                        Icons.calendar_today_outlined,
                        _currentDate
                    ),

                    SizedBox(
                      height:_size.width * 0.05,
                    ),

                    rowDetails(
                        _size,
                        Icons.access_time_outlined,
                        _currentHour
                    ),

                    SizedBox(
                      height:_size.width * 0.05,
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
                        _sendNewPoint(
                          point,
                          currentAddress,
                          _currentHour,
                          _currentDate,
                          _textController.text,
                        );
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

  Row rowDetails(Size _size, IconData iconData, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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

  void _sendNewPoint(LatLng latLng, String address, String hour, String date, String comment) async {
    await EasyLoading.show(
      status: 'Enviando\ninformación...',
    );

    MosquitoPointModel mosquitoPoint = MosquitoPointModel(
      direccion: address,
      hora: hour,
      fecha: date,
      latitud: latLng.latitude,
      longitud: latLng.longitude,
      comentario: comment,
    );

    MosquitoPointProvider mosquitoPointProvider = MosquitoPointProvider();
    bool response = await mosquitoPointProvider.createMosquitoPoint(mosquitoPoint);

    // Ocultar ícono de carga
    await EasyLoading.dismiss();

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

