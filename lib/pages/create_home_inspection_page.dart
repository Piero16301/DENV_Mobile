import 'dart:io';

import 'package:denv_mobile/models/inspection/containers/containers.dart';
import 'package:denv_mobile/models/inspection/inspection.dart';
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

class CreateHomeInspectionPage extends StatelessWidget {
  const CreateHomeInspectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final homeInspectionService = Provider.of<HomeInspectionService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva inspección de vivienda'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: size.width * 0.05),
            PhotoDisplayAndSelectHomeInspection(size: size),
            SizedBox(height: size.width * 0.05),
            ShowAddressHomeInspection(size: size),
            SizedBox(height: size.width * 0.05),
            ShowCurrentDateTimeHomeInspection(size: size),
            SizedBox(height: size.width * 0.05),
            ShowLatitudeAndLongitudeHomeInspection(size: size),
            SizedBox(height: size.width * 0.05),
            InsertCommentHomeInspection(size: size),
            SizedBox(height: size.width * 0.05),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newHomeInspectionButton',
        onPressed: homeInspectionService.isSavingNewHomeInspection
            ? null
            : () async {
                // Subir fotografía a Cloudinary
                String? photoUrl = homeInspectionProvider.image != null
                    ? await homeInspectionService.uploadImage(
                        homeInspectionProvider.image!,
                      )
                    : 'Sin enlace';

                if (photoUrl == null) {
                  await _showResponseDialog(success: false, context: context);
                  return;
                }

                // Crear objeto de tipo HomeInspection
                final homeInspection = HomeInspectionModel(
                  address: AddressModel(
                    formattedaddress:
                        homeInspectionProvider.address!.formattedAddress!,
                    postalcode: getAddressComponent(
                      homeInspectionProvider.address!,
                      'postal_code',
                    ),
                    country: getAddressComponent(
                      homeInspectionProvider.address!,
                      'country',
                    ),
                    department: getAddressComponent(
                      homeInspectionProvider.address!,
                      'administrative_area_level_1',
                    ),
                    province: getAddressComponent(
                      homeInspectionProvider.address!,
                      'administrative_area_level_2',
                    ),
                    district: getAddressComponent(
                      homeInspectionProvider.address!,
                      'locality',
                    ),
                    urbanization: getAddressComponent(
                      homeInspectionProvider.address!,
                      'sublocality_level_1',
                    ),
                    street: getAddressComponent(
                      homeInspectionProvider.address!,
                      'route',
                    ),
                    block: 'C-2',
                    lot: 40,
                    streetnumber: int.parse(
                      getAddressComponent(
                        homeInspectionProvider.address!,
                        'street_number',
                      ),
                    ),
                  ),
                  comment: homeInspectionProvider.comment ?? 'Sin comentario',
                  datetime: homeInspectionProvider.datetime!,
                  dni: '74044313',
                  latitude: homeInspectionProvider.position!.latitude,
                  longitude: homeInspectionProvider.position!.longitude,
                  photourl: photoUrl,
                  numberinhabitants: 10,
                  homecondition: HomeConditionModel(
                    inspectedhome: 1,
                    reluctantdwelling: 2,
                    closedhome: 3,
                    uninhabitedhouse: 4,
                    housingspotlights: 5,
                    treatedhousing: 6,
                  ),
                  typecontainers: TypeContainersModel(
                    elevatedtank: ElevatedTankModel(i: 1, p: 2, t: 3),
                    lowtank: LowTankModel(i: 1, p: 2, t: 3),
                    cylinderbarrel: CylinderBarrelModel(i: 1, p: 2, t: 3),
                    buckettub: BucketTubModel(i: 1, p: 2, t: 3),
                    tire: TireModel(i: 1, p: 2, t: 3),
                    flower: FlowerModel(i: 1, p: 2, t: 3),
                    useless: UselessModel(i: 1, p: 2, t: 3),
                    others: OthersModel(i: 1, p: 2, t: 3),
                  ),
                  totalcontainer: TotalContainerModel(
                    inspectedcontainers: 1,
                    containersspotlights: 2,
                    treatedcontainers: 3,
                    destroyedcontainers: 4,
                  ),
                  aegyptifocus: AegyptiFocusModel(
                    larvae: 1,
                    pupae: 2,
                    adult: 3,
                  ),
                );

                // Subir reporte de caso a MongoDB
                final newHomeInspection =
                    await homeInspectionService.createNewHomeInspection(
                  homeInspection,
                );

                if (newHomeInspection != null) {
                  await _showResponseDialog(success: true, context: context);
                } else {
                  await _showResponseDialog(success: false, context: context);
                }
              },
        label: Text(
          homeInspectionService.isSavingNewHomeInspection
              ? 'Guardando...'
              : 'Guardar',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: homeInspectionService.isSavingNewHomeInspection
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

class PhotoDisplayAndSelectHomeInspection extends StatelessWidget {
  const PhotoDisplayAndSelectHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: size.width * 0.8,
                height: (size.width * 0.8) * 0.75,
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
                child: homeInspectionProvider.image == null
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
                          homeInspectionProvider.image!,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              if (homeInspectionProvider.image != null)
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
                      homeInspectionProvider.setImage(null);
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
                  child: PhotoFromCameraButtonHomeInspection(),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: PhotoFromGalleryButtonHomeInspection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoFromCameraButtonHomeInspection extends StatelessWidget {
  const PhotoFromCameraButtonHomeInspection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return ElevatedButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
        );
        if (pickedFile != null) {
          homeInspectionProvider.setImage(File(pickedFile.path));
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

class PhotoFromGalleryButtonHomeInspection extends StatelessWidget {
  const PhotoFromGalleryButtonHomeInspection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return ElevatedButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          homeInspectionProvider.setImage(File(pickedFile.path));
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

class InsertCommentHomeInspection extends StatelessWidget {
  const InsertCommentHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(
      context,
      listen: false,
    );

    return SizedBox(
      width: size.width * 0.8,
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
              homeInspectionProvider.setComment(value);
            },
          ),
        ],
      ),
    );
  }
}

class ShowCurrentDateTimeHomeInspection extends StatelessWidget {
  const ShowCurrentDateTimeHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return SizedBox(
      width: size.width * 0.8,
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
                        homeInspectionProvider.datetime!,
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
                        homeInspectionProvider.datetime!,
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

class ShowLatitudeAndLongitudeHomeInspection extends StatelessWidget {
  const ShowLatitudeAndLongitudeHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return SizedBox(
      width: size.width * 0.8,
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
                      homeInspectionProvider.position!.latitude
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
                      color:
                          ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      homeInspectionProvider.position!.longitude
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

class ShowAddressHomeInspection extends StatelessWidget {
  const ShowAddressHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return SizedBox(
      width: size.width * 0.8,
      child: ExpansionTile(
        title: const Text(
          'Dirección',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        children: [
          AddressRowTile(
            tileTitle: 'Cód. postal',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'postal_code',
            ),
          ),
          AddressRowTile(
            tileTitle: 'País:',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'country',
            ),
          ),
          AddressRowTile(
            tileTitle: 'Departamento:',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'administrative_area_level_1',
            ),
          ),
          AddressRowTile(
            tileTitle: 'Provincia:',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'administrative_area_level_2',
            ),
          ),
          AddressRowTile(
            tileTitle: 'Distrito:',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'locality',
            ),
          ),
          AddressRowTile(
            tileTitle: 'Urbanización:',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'sublocality_level_1',
            ),
          ),
          AddressRowTile(
            tileTitle: 'Calle:',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'route',
            ),
          ),
          AddressRowTile(
            tileTitle: 'Número:',
            tileContent: getAddressComponent(
              homeInspectionProvider.address!,
              'street_number',
            ),
          ),
          AddressRowTile(
            tileTitle: 'Dirección:',
            tileContent: homeInspectionProvider.address!.formattedAddress!,
          ),
          const BlockInputHomeInspection(),
          const LotInputHomeInspection(),
        ],
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

class BlockInputHomeInspection extends StatelessWidget {
  const BlockInputHomeInspection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(
      context,
      listen: false,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 125,
            child: Text(
              'Manzana:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: 100,
              child: TextField(
                onChanged: (value) {
                  homeInspectionProvider.setBlock(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Mz.',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LotInputHomeInspection extends StatelessWidget {
  const LotInputHomeInspection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(
      context,
      listen: false,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 125,
            child: Text(
              'Lote:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: 100,
              child: TextField(
                onChanged: (value) {
                  if (int.tryParse(value) != null) {
                    homeInspectionProvider.setLot(int.parse(value));
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Lt.',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressRowTile extends StatelessWidget {
  const AddressRowTile({
    Key? key,
    required this.tileTitle,
    required this.tileContent,
  }) : super(key: key);

  final String tileTitle;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 125,
            child: Text(
              tileTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: TextScroll(
              tileContent,
              mode: TextScrollMode.bouncing,
              velocity: const Velocity(
                pixelsPerSecond: Offset(25, 0),
              ),
              delayBefore: const Duration(milliseconds: 500),
              pauseBetween: const Duration(milliseconds: 50),
              style: const TextStyle(
                fontSize: 16,
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
