import 'dart:io';

import 'package:denv_mobile/models/models.dart';
import 'package:denv_mobile/providers/providers.dart';
import 'package:denv_mobile/services/services.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class CreateVectorRecordPage extends StatelessWidget {
  const CreateVectorRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(context);
    final vectorRecordService = Provider.of<VectorRecordService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo registro del vector'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            PhotoDisplayAndSelectVectorRecord(size: size),
            const SizedBox(height: 30),
            InsertCommentVectorRecord(size: size),
            const SizedBox(height: 20),
            ShowCurrentDateTimeVectorRecord(size: size),
            const SizedBox(height: 30),
            ShowLatitudeAndLongitudeVectorRecord(size: size),
            const SizedBox(height: 30),
            ShowAddressVectorRecord(size: size),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newVectorRecordButton',
        onPressed: vectorRecordService.isSavingNewVectorRecord
            ? null
            : () async {
                // Subir fotografía a Cloudinary
                String? photoUrl = vectorRecordProvider.image != null
                    ? await vectorRecordService.uploadImage(
                        vectorRecordProvider.image!,
                      )
                    : 'Sin enlace';

                if (photoUrl == null) {
                  await _showResponseDialog(success: false, context: context);
                  return;
                }

                // Crear objeto de tipo VectorRecord
                final vectorRecord = VectorRecordModel(
                  address: AddressModel(
                    formattedaddress:
                        vectorRecordProvider.address!.formattedAddress!,
                    postalcode: getAddressComponent(
                      vectorRecordProvider.address!,
                      'postal_code',
                    ),
                    country: getAddressComponent(
                      vectorRecordProvider.address!,
                      'country',
                    ),
                    department: getAddressComponent(
                      vectorRecordProvider.address!,
                      'administrative_area_level_1',
                    ),
                    province: getAddressComponent(
                      vectorRecordProvider.address!,
                      'administrative_area_level_2',
                    ),
                    district: getAddressComponent(
                      vectorRecordProvider.address!,
                      'administrative_area_level_3',
                    ),
                    urbanization: getAddressComponent(
                      vectorRecordProvider.address!,
                      'sublocality_level_1',
                    ),
                    street: getAddressComponent(
                      vectorRecordProvider.address!,
                      'route',
                    ),
                    block: 'C-2',
                    lot: 40,
                    streetnumber: int.parse(
                      getAddressComponent(
                        vectorRecordProvider.address!,
                        'street_number',
                      ),
                    ),
                  ),
                  comment: vectorRecordProvider.comment ?? 'Sin comentario',
                  datetime: vectorRecordProvider.datetime!,
                  latitude: vectorRecordProvider.position!.latitude,
                  longitude: vectorRecordProvider.position!.longitude,
                  photourl: photoUrl,
                );

                // Subir zona de propagación a MongoDB
                final newVectorRecord =
                    await vectorRecordService.createNewVectorRecord(
                  vectorRecord,
                );
                if (newVectorRecord != null) {
                  await _showResponseDialog(success: true, context: context);
                } else {
                  await _showResponseDialog(success: false, context: context);
                }
              },
        label: Text(
          vectorRecordService.isSavingNewVectorRecord
              ? 'Guardando...'
              : 'Guardar',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: vectorRecordService.isSavingNewVectorRecord
            ? SizedBox.square(
                dimension: 30,
                child: CircularProgressIndicator(
                  backgroundColor:
                      ThemeModeApp.isDarkMode ? Colors.black : Colors.white,
                ),
              )
            : const Icon(Icons.save),
        elevation: 1,
      ),
    );
  }

  String getAddressComponent(GeocodingResult result, String type) {
    final addressComponent = result.addressComponents!.firstWhere(
      (element) => element.types!.contains(type),
      orElse: () => AddressComponent(),
    );
    return addressComponent.longName ?? 'No registrado';
  }

  Future<void> _showResponseDialog({
    required bool success,
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                success ? 'Éxito' : 'Error',
                style: TextStyle(
                  color: success ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Text(
            success
                ? 'Se ha guardado el reporte de caso de dengue correctamente'
                : 'Ha ocurrido un error al guardar el reporte de caso de dengue',
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 10),
          actions: [
            ElevatedButton(
              onPressed: () => success
                  ? Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (_) => false,
                    )
                  : Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                elevation: 1,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PhotoDisplayAndSelectVectorRecord extends StatelessWidget {
  const PhotoDisplayAndSelectVectorRecord({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(context);

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: size.width - 100,
                height: (size.width - 100) * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 3,
                    color: ThemeModeApp.isDarkMode
                        ? const Color.fromARGB(255, 189, 189, 189)
                        : const Color.fromARGB(255, 77, 77, 77),
                  ),
                  color: ThemeModeApp.isDarkMode
                      ? const Color.fromARGB(255, 66, 66, 66)
                      : const Color.fromARGB(255, 185, 185, 185),
                ),
                child: vectorRecordProvider.image == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 75),
                        child: SvgPicture.asset(
                          'assets/app_icons/no-image.svg',
                          color: (ThemeModeApp.isDarkMode)
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          vectorRecordProvider.image!,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              if (vectorRecordProvider.image != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 30,
                    ),
                    color:
                        ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
                    onPressed: () {
                      vectorRecordProvider.setImage(null);
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(
                  child: PhotoFromCameraButtonVectorRecord(),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: PhotoFromGalleryButtonVectorRecord(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoFromCameraButtonVectorRecord extends StatelessWidget {
  const PhotoFromCameraButtonVectorRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(context);

    return ElevatedButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
        );
        if (pickedFile != null) {
          vectorRecordProvider.setImage(File(pickedFile.path));
        }
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(1),
        fixedSize: MaterialStateProperty.all<Size>(
          const Size.fromHeight(40),
        ),
      ),
      child: const Text(
        'Tomar foto',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class PhotoFromGalleryButtonVectorRecord extends StatelessWidget {
  const PhotoFromGalleryButtonVectorRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(context);

    return ElevatedButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          vectorRecordProvider.setImage(File(pickedFile.path));
        }
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(1),
        fixedSize: MaterialStateProperty.all<Size>(
          const Size.fromHeight(40),
        ),
      ),
      child: const Text(
        'Seleccionar foto',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class InsertCommentVectorRecord extends StatelessWidget {
  const InsertCommentVectorRecord({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(
      context,
      listen: false,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comentario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: ThemeModeApp.isDarkMode
                      ? const Color.fromARGB(255, 189, 189, 189)
                      : const Color.fromARGB(255, 77, 77, 77),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: ThemeModeApp.isDarkMode
                      ? const Color.fromARGB(255, 189, 189, 189)
                      : const Color.fromARGB(255, 77, 77, 77),
                ),
              ),
              hintText: 'Escribe un comentario (máximo 200 caracteres)',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            maxLines: 3,
            maxLength: 200,
            onChanged: (value) {
              vectorRecordProvider.setComment(value);
            },
          ),
        ],
      ),
    );
  }
}

class ShowCurrentDateTimeVectorRecord extends StatelessWidget {
  const ShowCurrentDateTimeVectorRecord({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fecha y hora',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat.yMMMd('es_ES').format(
                        vectorRecordProvider.datetime!,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('hh:mm:ss a').format(
                        vectorRecordProvider.datetime!,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowLatitudeAndLongitudeVectorRecord extends StatelessWidget {
  const ShowLatitudeAndLongitudeVectorRecord({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latitud y longitud',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/app_icons/latitude_icon.svg',
                      height: 30,
                      width: 30,
                      color: (ThemeModeApp.isDarkMode)
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      vectorRecordProvider.position!.latitude
                          .toStringAsFixed(5),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/app_icons/longitude_icon.svg',
                      height: 30,
                      width: 30,
                      color: (ThemeModeApp.isDarkMode)
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      vectorRecordProvider.position!.longitude
                          .toStringAsFixed(5),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowAddressVectorRecord extends StatelessWidget {
  const ShowAddressVectorRecord({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final vectorRecordProvider = Provider.of<VectorRecordProvider>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dirección',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: TextScroll(
                      vectorRecordProvider.address!.formattedAddress!,
                      mode: TextScrollMode.bouncing,
                      velocity: const Velocity(
                        pixelsPerSecond: Offset(25, 0),
                      ),
                      delayBefore: const Duration(milliseconds: 500),
                      pauseBetween: const Duration(milliseconds: 50),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
