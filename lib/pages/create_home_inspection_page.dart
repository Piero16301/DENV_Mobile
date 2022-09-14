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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            children: [
              SizedBox(height: size.width * 0.05),
              DNIInputHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              ShowAddressHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              NumberInhabitantsInputHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              HomeConditionHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              TypeContainersHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              TotalContainerHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              AegyptiFocusHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              LarvicideInputHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              ShowCurrentDateTimeHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              ShowLatitudeAndLongitudeHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              InsertCommentHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
              PhotoDisplayAndSelectHomeInspection(size: size),
              SizedBox(height: size.width * 0.05),
            ],
          ),
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
                    block: homeInspectionProvider.block ?? 'Sin manzana',
                    lot: homeInspectionProvider.lot ?? -1,
                    streetnumber: int.parse(
                      getAddressComponent(
                        homeInspectionProvider.address!,
                        'street_number',
                      ),
                    ),
                  ),
                  comment: homeInspectionProvider.comment ?? 'Sin comentario',
                  datetime: homeInspectionProvider.datetime!,
                  dni: homeInspectionProvider.dni ?? 'Sin DNI',
                  latitude: homeInspectionProvider.position!.latitude,
                  longitude: homeInspectionProvider.position!.longitude,
                  photourl: photoUrl,
                  numberinhabitants:
                      homeInspectionProvider.numberInhabitants ?? -1,
                  homecondition: HomeConditionModel(
                    inspectedhome: homeInspectionProvider.inspectedHome ?? -1,
                    reluctantdwelling:
                        homeInspectionProvider.reluctantDwelling ?? -1,
                    closedhome: homeInspectionProvider.closedHouse ?? -1,
                    uninhabitedhouse:
                        homeInspectionProvider.uninhabitedHouse ?? -1,
                    housingspotlights:
                        homeInspectionProvider.housingSpotlights ?? -1,
                    treatedhousing: homeInspectionProvider.treatedHousing ?? -1,
                  ),
                  typecontainers: TypeContainersModel(
                    elevatedtank: ElevatedTankModel(
                      i: homeInspectionProvider.elevatedTankI ?? -1,
                      p: homeInspectionProvider.elevatedTankP ?? -1,
                      t: homeInspectionProvider.elevatedTankT ?? -1,
                    ),
                    lowtank: LowTankModel(
                      i: homeInspectionProvider.lowTankI ?? -1,
                      p: homeInspectionProvider.lowTankP ?? -1,
                      t: homeInspectionProvider.lowTankT ?? -1,
                    ),
                    cylinderbarrel: CylinderBarrelModel(
                      i: homeInspectionProvider.cylinderBarrelI ?? -1,
                      p: homeInspectionProvider.cylinderBarrelP ?? -1,
                      t: homeInspectionProvider.cylinderBarrelT ?? -1,
                    ),
                    buckettub: BucketTubModel(
                      i: homeInspectionProvider.bucketTubI ?? -1,
                      p: homeInspectionProvider.bucketTubP ?? -1,
                      t: homeInspectionProvider.bucketTubT ?? -1,
                    ),
                    tire: TireModel(
                      i: homeInspectionProvider.tireI ?? -1,
                      p: homeInspectionProvider.tireP ?? -1,
                      t: homeInspectionProvider.tireT ?? -1,
                    ),
                    flower: FlowerModel(
                      i: homeInspectionProvider.flowerI ?? -1,
                      p: homeInspectionProvider.flowerP ?? -1,
                      t: homeInspectionProvider.flowerT ?? -1,
                    ),
                    useless: UselessModel(
                      i: homeInspectionProvider.uselessI ?? -1,
                      p: homeInspectionProvider.uselessP ?? -1,
                      t: homeInspectionProvider.uselessT ?? -1,
                    ),
                    others: OthersModel(
                      i: homeInspectionProvider.othersI ?? -1,
                      p: homeInspectionProvider.othersP ?? -1,
                      t: homeInspectionProvider.othersT ?? -1,
                    ),
                  ),
                  totalcontainer: TotalContainerModel(
                    inspectedcontainers:
                        homeInspectionProvider.inspectedContainers ?? -1,
                    containersspotlights:
                        homeInspectionProvider.containersSpotlights ?? -1,
                    treatedcontainers:
                        homeInspectionProvider.treatedContainers ?? -1,
                    destroyedcontainers:
                        homeInspectionProvider.destroyedContainers ?? -1,
                  ),
                  aegyptifocus: AegyptiFocusModel(
                    larvae: homeInspectionProvider.larvae ?? -1,
                    pupae: homeInspectionProvider.pupae ?? -1,
                    adult: homeInspectionProvider.adult ?? -1,
                  ),
                  larvicide: homeInspectionProvider.larvicide ?? 0.0,
                );

                // Subir reporte de caso a MongoDB
                final newHomeInspection =
                    await homeInspectionService.createNewHomeInspection(
                  homeInspection,
                );

                if (newHomeInspection) {
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

class DNIInputHomeInspection extends StatelessWidget {
  const DNIInputHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.3,
          child: const Text(
            'DNI:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: 'Ingrese el DNI',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.dni ?? '',
            onChanged: (value) {
              if (value.length == 8) {
                homeInspectionProvider.setDni(value);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (value.length != 8) {
                return 'DNI inválido';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
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

    return Column(
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
                  color: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
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
              child: TextFormField(
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
                  hintText: 'Mz.',
                  hintStyle: TextStyle(
                    color: ThemeModeApp.isDarkMode
                        ? const Color.fromARGB(255, 189, 189, 189)
                        : const Color.fromARGB(255, 77, 77, 77),
                  ),
                ),
                initialValue: homeInspectionProvider.block,
                onChanged: (value) {
                  homeInspectionProvider.setBlock(value);
                },
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
              child: TextFormField(
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
                  hintText: 'Lt.',
                  hintStyle: TextStyle(
                    color: ThemeModeApp.isDarkMode
                        ? const Color.fromARGB(255, 189, 189, 189)
                        : const Color.fromARGB(255, 77, 77, 77),
                  ),
                ),
                initialValue: homeInspectionProvider.lot == null
                    ? ''
                    : homeInspectionProvider.lot.toString(),
                onChanged: (value) {
                  if (int.tryParse(value) != null) {
                    homeInspectionProvider.setLot(int.parse(value));
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un entero';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumberInhabitantsInputHomeInspection extends StatelessWidget {
  const NumberInhabitantsInputHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'N° de habitantes:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: 'N°',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.numberInhabitants == null
                ? ''
                : homeInspectionProvider.numberInhabitants.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setNumberInhabitants(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class HomeConditionHomeInspection extends StatelessWidget {
  const HomeConditionHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );

    return SizedBox(
      width: size.width * 0.8,
      child: ExpansionTile(
        title: const Text(
          'Condición de vivienda',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        children: [
          InspectedHomeInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          ReluctantDwellingInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          ClosedHouseInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          UninhabitedHouseInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          HousingSpotlightsInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          TreatedHousingInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class InspectedHomeInputHomeInspection extends StatelessWidget {
  const InspectedHomeInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Vivienda inspeccionada:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.inspectedHome == null
                ? ''
                : homeInspectionProvider.inspectedHome.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setInspectedHome(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class ReluctantDwellingInputHomeInspection extends StatelessWidget {
  const ReluctantDwellingInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Vivienda renuente:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.reluctantDwelling == null
                ? ''
                : homeInspectionProvider.reluctantDwelling.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setReluctantDwelling(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class ClosedHouseInputHomeInspection extends StatelessWidget {
  const ClosedHouseInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Vivienda cerrada:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.closedHouse == null
                ? ''
                : homeInspectionProvider.closedHouse.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setClosedHouse(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class UninhabitedHouseInputHomeInspection extends StatelessWidget {
  const UninhabitedHouseInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Vivienda deshabitada:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.uninhabitedHouse == null
                ? ''
                : homeInspectionProvider.uninhabitedHouse.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setUninhabitedHouse(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class HousingSpotlightsInputHomeInspection extends StatelessWidget {
  const HousingSpotlightsInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Vivienda focos:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.housingSpotlights == null
                ? ''
                : homeInspectionProvider.housingSpotlights.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setHousingSpotlights(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class TreatedHousingInputHomeInspection extends StatelessWidget {
  const TreatedHousingInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Vivienda tratada con abte:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.treatedHousing == null
                ? ''
                : homeInspectionProvider.treatedHousing.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setTreatedHousing(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class TypeContainersHomeInspection extends StatelessWidget {
  const TypeContainersHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );

    return SizedBox(
      width: size.width * 0.8,
      child: ExpansionTile(
        title: const Text(
          'Tipo de recipientes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        children: [
          ElevatedTankInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          LowTankInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          CylinderBarrelInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          BucketTubInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          TireInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          FlowerInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          UselessInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          OthersInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ElevatedTankInputHomeInspection extends StatelessWidget {
  const ElevatedTankInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Tanque elevado',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.elevatedTankI == null
                        ? ''
                        : homeInspectionProvider.elevatedTankI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider
                            .setElevatedTankI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.elevatedTankP == null
                        ? ''
                        : homeInspectionProvider.elevatedTankP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider
                            .setElevatedTankP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.elevatedTankT == null
                        ? ''
                        : homeInspectionProvider.elevatedTankT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider
                            .setElevatedTankT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class LowTankInputHomeInspection extends StatelessWidget {
  const LowTankInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Tanque bajo, pozos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.lowTankI == null
                        ? ''
                        : homeInspectionProvider.lowTankI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setLowTankI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.lowTankP == null
                        ? ''
                        : homeInspectionProvider.lowTankP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setLowTankP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.lowTankT == null
                        ? ''
                        : homeInspectionProvider.lowTankT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setLowTankT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class CylinderBarrelInputHomeInspection extends StatelessWidget {
  const CylinderBarrelInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Barril, cilindro sanson',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.cylinderBarrelI == null
                        ? ''
                        : homeInspectionProvider.cylinderBarrelI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider
                            .setCylinderBarrelI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.cylinderBarrelP == null
                        ? ''
                        : homeInspectionProvider.cylinderBarrelP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider
                            .setCylinderBarrelP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.cylinderBarrelT == null
                        ? ''
                        : homeInspectionProvider.cylinderBarrelT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider
                            .setCylinderBarrelT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class BucketTubInputHomeInspection extends StatelessWidget {
  const BucketTubInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Balde, abtea, tina',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.bucketTubI == null
                        ? ''
                        : homeInspectionProvider.bucketTubI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setBucketTubI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.bucketTubP == null
                        ? ''
                        : homeInspectionProvider.bucketTubP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setBucketTubP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.bucketTubT == null
                        ? ''
                        : homeInspectionProvider.bucketTubT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setBucketTubT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TireInputHomeInspection extends StatelessWidget {
  const TireInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Llanta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.tireI == null
                        ? ''
                        : homeInspectionProvider.tireI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setTireI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.tireP == null
                        ? ''
                        : homeInspectionProvider.tireP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setTireP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.tireT == null
                        ? ''
                        : homeInspectionProvider.tireT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setTireT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class FlowerInputHomeInspection extends StatelessWidget {
  const FlowerInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Florero, maceta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.flowerI == null
                        ? ''
                        : homeInspectionProvider.flowerI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setFlowerI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.flowerP == null
                        ? ''
                        : homeInspectionProvider.flowerP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setFlowerP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.flowerT == null
                        ? ''
                        : homeInspectionProvider.flowerT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setFlowerT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class UselessInputHomeInspection extends StatelessWidget {
  const UselessInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Inservibles',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.uselessI == null
                        ? ''
                        : homeInspectionProvider.uselessI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setUselessI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.uselessP == null
                        ? ''
                        : homeInspectionProvider.uselessP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setUselessP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.uselessT == null
                        ? ''
                        : homeInspectionProvider.uselessT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setUselessT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class OthersInputHomeInspection extends StatelessWidget {
  const OthersInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Text(
          'Otros',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'I',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.othersI == null
                        ? ''
                        : homeInspectionProvider.othersI.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setOthersI(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.othersP == null
                        ? ''
                        : homeInspectionProvider.othersP.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setOthersP(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ThemeModeApp.isDarkMode
                            ? const Color.fromARGB(255, 189, 189, 189)
                            : const Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: homeInspectionProvider.othersT == null
                        ? ''
                        : homeInspectionProvider.othersT.toString(),
                    onChanged: (value) {
                      if (int.tryParse(value) != null) {
                        homeInspectionProvider.setOthersT(int.parse(value));
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un entero';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TotalContainerHomeInspection extends StatelessWidget {
  const TotalContainerHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );

    return SizedBox(
      width: size.width * 0.8,
      child: ExpansionTile(
        title: const Text(
          'Total de recipiente',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        children: [
          InspectedContainersInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          ContainersSpotlightsInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          TreatedContainersInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          DestroyedContainersInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class InspectedContainersInputHomeInspection extends StatelessWidget {
  const InspectedContainersInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Recipientes inspeccionados:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.inspectedContainers == null
                ? ''
                : homeInspectionProvider.inspectedContainers.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setInspectedContainers(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class ContainersSpotlightsInputHomeInspection extends StatelessWidget {
  const ContainersSpotlightsInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Recipientes focos:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.containersSpotlights == null
                ? ''
                : homeInspectionProvider.containersSpotlights.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider
                    .setContainersSpotlights(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class TreatedContainersInputHomeInspection extends StatelessWidget {
  const TreatedContainersInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Recipientes tratados:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.treatedContainers == null
                ? ''
                : homeInspectionProvider.treatedContainers.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setTreatedContainers(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class DestroyedContainersInputHomeInspection extends StatelessWidget {
  const DestroyedContainersInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Recipientes destruidos:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.destroyedContainers == null
                ? ''
                : homeInspectionProvider.destroyedContainers.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setDestroyedContainers(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class AegyptiFocusHomeInspection extends StatelessWidget {
  const AegyptiFocusHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );

    return SizedBox(
      width: size.width * 0.8,
      child: ExpansionTile(
        title: const Text(
          'Foco de A. aegypti',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        children: [
          LarvaeInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          PupaeInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
          AdultInputHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class LarvaeInputHomeInspection extends StatelessWidget {
  const LarvaeInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Larvas:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.larvae == null
                ? ''
                : homeInspectionProvider.larvae.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setLarvae(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class PupaeInputHomeInspection extends StatelessWidget {
  const PupaeInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Pupas:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.pupae == null
                ? ''
                : homeInspectionProvider.pupae.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setPupae(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class AdultInputHomeInspection extends StatelessWidget {
  const AdultInputHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;

  @override
  Widget build(BuildContext context) {
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Adulto:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.adult == null
                ? ''
                : homeInspectionProvider.adult.toString(),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                homeInspectionProvider.setAdult(int.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (int.tryParse(value) == null) {
                return 'Ingrese un entero';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class LarvicideInputHomeInspection extends StatelessWidget {
  const LarvicideInputHomeInspection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 2,
        color: ThemeModeApp.isDarkMode
            ? const Color.fromARGB(255, 189, 189, 189)
            : const Color.fromARGB(255, 77, 77, 77),
      ),
    );
    final homeInspectionProvider = Provider.of<HomeInspectionProvider>(context);

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: const Text(
            'Larvicida (grs):',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              hintText: '0.0',
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            textAlign: TextAlign.center,
            initialValue: homeInspectionProvider.larvicide == null
                ? ''
                : homeInspectionProvider.larvicide.toString(),
            onChanged: (value) {
              if (double.tryParse(value) != null) {
                homeInspectionProvider.setLarvicide(double.parse(value));
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (double.tryParse(value) == null) {
                return 'Ingrese un decimal';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
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
