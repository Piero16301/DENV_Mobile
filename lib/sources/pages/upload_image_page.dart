import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_photo_model.dart';
import 'package:deteccion_zonas_dengue/sources/providers/location_provider.dart';
import 'package:deteccion_zonas_dengue/sources/providers/mosquito_photo_provider.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);

  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  String currentAddress = '-';
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;

  @override
  void initState() {
    super.initState();

    getCurrentLocation().then((currentPosition) {
      getAddress(latitude: currentPosition.latitude, longitude: currentPosition.longitude).then((address) {
        currentAddress = address;
        currentLatitude = currentPosition.latitude;
        currentLongitude = currentPosition.longitude;

        setState(() {});
      });
      setState(() {});
    });

    // Inicializar el loader
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 50.0
      ..animationStyle = EasyLoadingAnimationStyle.scale
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.black;
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final File image = ModalRoute.of(context)!.settings.arguments as File;
    final DateTime _currentTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff2c5364),
        elevation: 3.0,
        title: const Center(
          child: Text(
            'Agregar foto',
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
                'Fotografía',
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

            Center(
              child: Container(
                height: _size.width * 0.9,
                width: _size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xff2c5364),
                    width: 3,
                  ),
                ),
                child: Image.file(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(
              height: _size.width * 0.05,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                  DateFormat('dd-MM-yyyy').format(_currentTime),
                ),

                SizedBox(
                  height:_size.width * 0.05,
                ),

                rowDetails(
                  _size,
                  Icons.access_time_outlined,
                  DateFormat('Hms').format(_currentTime),
                ),
              ],
            ),

            SizedBox(
              height: _size.width * 0.1,
            ),

            ElevatedButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.send, size: 60),
                  Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                elevation: MaterialStateProperty.all<double>(3.0),
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff2c5364)),
                maximumSize: MaterialStateProperty.all<Size>(Size(_size.width * 0.25, _size.width * 0.25)),
                minimumSize: MaterialStateProperty.all<Size>(Size(_size.width * 0.25, _size.width * 0.25)),
              ),
              onPressed: () async {
                await EasyLoading.show(
                  status: 'Enviando\ninformación...',
                );

                MosquitoPhotoProvider mosquitoPhotoProvider = MosquitoPhotoProvider();
                String photoUrl = await mosquitoPhotoProvider.uploadPhoto(image);
                if (photoUrl == '-') {
                  showDialogCreatePoint(
                    false,
                    'Foto no subida',
                    'Verifica tu conexión a internet e intenta crear el punto nuevamente',
                  );
                }

                String dateFormat = "${DateFormat('yyyy-MM-dd').format(_currentTime)}T${DateFormat('Hms').format(_currentTime)}.000+00:00";

                MosquitoPhotoModel mosquitoPhotoModel = MosquitoPhotoModel(
                  address: currentAddress,
                  comment: 'Sin comentario',
                  datetime: DateTime.parse(dateFormat),
                  latitude: currentLatitude,
                  longitude: currentLongitude,
                  photourl: photoUrl,
                );

                bool response = await mosquitoPhotoProvider.createMosquitoPhoto(mosquitoPhotoModel);

                // Ocultar ícono de carga
                await EasyLoading.dismiss();

                if (response) {
                  showDialogCreatePoint(
                    true,
                    'Éxito',
                    'La foto ha sido guardada correctamente en la base de datos',
                  );
                } else {
                  showDialogCreatePoint(
                    false,
                    'Error',
                    'Verifica tu conexión a internet e intenta crear el punto nuevamente',
                  );
                }
              },
            ),

            SizedBox(
              height: _size.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showDialogCreatePoint(bool success, String title, String content) {
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xff2c5364),
                  ),
                ),
              ),
              content: Text(
                content,
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

