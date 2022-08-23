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

class CreateCaseReport extends StatelessWidget {
  const CreateCaseReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final caseReportProvider = Provider.of<CaseReportProvider>(context);
    final caseReportService = Provider.of<CaseReportService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar nuevo caso de dengue'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            PhotoDisplayAndSelect(size: size),
            const SizedBox(height: 30),
            InsertComment(size: size),
            const SizedBox(height: 20),
            ShowCurrentDateTime(size: size),
            const SizedBox(height: 30),
            ShowLatitudeAndLongitude(size: size),
            const SizedBox(height: 30),
            ShowAddress(size: size),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Subir fotografía a Cloudinary
          String photoUrl = caseReportProvider.image != null
              ? await caseReportService.uploadImage(
                    caseReportProvider.image!,
                  ) ??
                  'Sin fotografía'
              : 'Sin fotografía';

          // Crear objeto de tipo CaseReport
          final caseReport = CaseReportModel(
            address: AddressModel(
              formattedAddress: caseReportProvider.address!.formattedAddress!,
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
              await caseReportService.createNewCaseReport(caseReport);
          if (newCaseReport != null) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        label: const Text(
          'Guardar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(Icons.save),
        elevation: 5,
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
}

class PhotoDisplayAndSelect extends StatelessWidget {
  const PhotoDisplayAndSelect({
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
                          color: (ThemeModeApp.isDarkMode)
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    : Image.file(
                        caseReportProvider.image!,
                        fit: BoxFit.contain,
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
                  child: PhotoFromCameraButton(),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: PhotoFromGalleryButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoFromCameraButton extends StatelessWidget {
  const PhotoFromCameraButton({
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

class PhotoFromGalleryButton extends StatelessWidget {
  const PhotoFromGalleryButton({
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

class InsertComment extends StatelessWidget {
  const InsertComment({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
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
              Provider.of<CaseReportProvider>(context, listen: false)
                  .setComment(value);
            },
          ),
        ],
      ),
    );
  }
}

class ShowCurrentDateTime extends StatelessWidget {
  const ShowCurrentDateTime({
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
          Container(
            // decoration: BoxDecoration(
            //   borderRadius: const BorderRadius.all(
            //     Radius.circular(15),
            //   ),
            //   border: Border.all(
            //     width: 2,
            //     color: ThemeModeApp.isDarkMode
            //         ? const Color.fromARGB(255, 189, 189, 189)
            //         : const Color.fromARGB(255, 77, 77, 77),
            //   ),
            // ),
            child: Padding(
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
          ),
        ],
      ),
    );
  }
}

class ShowLatitudeAndLongitude extends StatelessWidget {
  const ShowLatitudeAndLongitude({
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
          Container(
            // decoration: BoxDecoration(
            //   borderRadius: const BorderRadius.all(
            //     Radius.circular(15),
            //   ),
            //   border: Border.all(
            //     width: 2,
            //     color: ThemeModeApp.isDarkMode
            //         ? const Color.fromARGB(255, 189, 189, 189)
            //         : const Color.fromARGB(255, 77, 77, 77),
            //   ),
            // ),
            child: Padding(
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
                        caseReportProvider.position!.latitude
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
                        caseReportProvider.position!.longitude
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
          ),
        ],
      ),
    );
  }
}

class ShowAddress extends StatelessWidget {
  const ShowAddress({
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
          Container(
            // decoration: BoxDecoration(
            //   borderRadius: const BorderRadius.all(
            //     Radius.circular(15),
            //   ),
            //   border: Border.all(
            //     width: 2,
            //     color: ThemeModeApp.isDarkMode
            //         ? const Color.fromARGB(255, 189, 189, 189)
            //         : const Color.fromARGB(255, 77, 77, 77),
            //   ),
            // ),
            child: Padding(
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
          ),
        ],
      ),
    );
  }
}