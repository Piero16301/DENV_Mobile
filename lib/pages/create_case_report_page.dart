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

class CreateCaseReportPage extends StatelessWidget {
  const CreateCaseReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final caseReportProvider = Provider.of<CaseReportProvider>(context);
    final caseReportService = Provider.of<CaseReportService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspección de viviendas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            PhotoDisplayAndSelectCaseReport(size: size),
            const SizedBox(height: 30),
            InsertCommentCaseReport(size: size),
            const SizedBox(height: 20),
            ShowCurrentDateTimeCaseReport(size: size),
            const SizedBox(height: 30),
            ShowLatitudeAndLongitudeCaseReport(size: size),
            const SizedBox(height: 30),
            ShowAddressCaseReport(size: size),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newCaseReportButton',
        onPressed: caseReportService.isSavingNewCaseReport
            ? null
            : () async {
                // Subir fotografía a Cloudinary
                String? photoUrl = caseReportProvider.image != null
                    ? await caseReportService.uploadImage(
                        caseReportProvider.image!,
                      )
                    : 'Sin enlace';

                if (photoUrl == null) {
                  await _showResponseDialog(success: false, context: context);
                  return;
                }

                // Crear objeto de tipo CaseReport
                final caseReport = CaseReportModel(
                  address: AddressModel(
                    formattedAddress:
                        caseReportProvider.address!.formattedAddress!,
                    postalCode: getAddressComponent(
                      caseReportProvider.address!,
                      'postal_code',
                    ),
                    country: getAddressComponent(
                      caseReportProvider.address!,
                      'country',
                    ),
                    department: getAddressComponent(
                      caseReportProvider.address!,
                      'administrative_area_level_1',
                    ),
                    province: getAddressComponent(
                      caseReportProvider.address!,
                      'administrative_area_level_2',
                    ),
                    district: getAddressComponent(
                      caseReportProvider.address!,
                      'administrative_area_level_3',
                    ),
                    urbanization: getAddressComponent(
                      caseReportProvider.address!,
                      'sublocality_level_1',
                    ),
                    street: getAddressComponent(
                      caseReportProvider.address!,
                      'route',
                    ),
                    streetNumber: int.parse(
                      getAddressComponent(
                        caseReportProvider.address!,
                        'street_number',
                      ),
                    ),
                  ),
                  comment: caseReportProvider.comment ?? 'Sin comentario',
                  dateTime: caseReportProvider.datetime!,
                  latitude: caseReportProvider.position!.latitude,
                  longitude: caseReportProvider.position!.longitude,
                  photoUrl: photoUrl,
                );

                // Subir reporte de caso a MongoDB
                final newCaseReport =
                    await caseReportService.createNewCaseReport(
                  caseReport,
                );
                if (newCaseReport != null) {
                  await _showResponseDialog(success: true, context: context);
                } else {
                  await _showResponseDialog(success: false, context: context);
                }
              },
        label: Text(
          caseReportService.isSavingNewCaseReport ? 'Guardando...' : 'Guardar',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: caseReportService.isSavingNewCaseReport
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

class PhotoDisplayAndSelectCaseReport extends StatelessWidget {
  const PhotoDisplayAndSelectCaseReport({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(context);

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
                child: caseReportProvider.image == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 75),
                        child: SvgPicture.asset(
                          'assets/app_icons/no-image.svg',
                          color: ThemeModeApp.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          caseReportProvider.image!,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              if (caseReportProvider.image != null)
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
                      caseReportProvider.setImage(null);
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
                  child: PhotoFromCameraButtonCaseReport(),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: PhotoFromGalleryButtonCaseReport(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoFromCameraButtonCaseReport extends StatelessWidget {
  const PhotoFromCameraButtonCaseReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(context);

    return ElevatedButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
        );
        if (pickedFile != null) {
          caseReportProvider.setImage(File(pickedFile.path));
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

class PhotoFromGalleryButtonCaseReport extends StatelessWidget {
  const PhotoFromGalleryButtonCaseReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(context);

    return ElevatedButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          caseReportProvider.setImage(File(pickedFile.path));
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

class InsertCommentCaseReport extends StatelessWidget {
  const InsertCommentCaseReport({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(
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
              caseReportProvider.setComment(value);
            },
          ),
        ],
      ),
    );
  }
}

class ShowCurrentDateTimeCaseReport extends StatelessWidget {
  const ShowCurrentDateTimeCaseReport({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(context);

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
                        caseReportProvider.datetime!,
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
                        caseReportProvider.datetime!,
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

class ShowLatitudeAndLongitudeCaseReport extends StatelessWidget {
  const ShowLatitudeAndLongitudeCaseReport({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(context);

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
                      color:
                          ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      caseReportProvider.position!.latitude.toStringAsFixed(5),
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
                      color:
                          ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      caseReportProvider.position!.longitude.toStringAsFixed(5),
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

class ShowAddressCaseReport extends StatelessWidget {
  const ShowAddressCaseReport({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final caseReportProvider = Provider.of<CaseReportProvider>(context);

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
                      caseReportProvider.address!.formattedAddress!,
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

// 1. DNI
// 2. Fecha y hora
// 3. Latitud y longitud
// 4. Dirección
// 5. Calle
// 6. Mz. Lote (input)
// 7. Nro. de habitantes (input)
// 8. Condición de viviendas
// 8.1. Casa
