import 'package:cached_network_image/cached_network_image.dart';
import 'package:denv_mobile/models/inspection/containers/containers.dart';
import 'package:denv_mobile/models/inspection/inspection.dart';
import 'package:denv_mobile/models/models.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

class HomeInspectionPage extends StatelessWidget {
  const HomeInspectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homeInspectionModel =
        ModalRoute.of(context)!.settings.arguments as HomeInspectionModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del la inspección de vivienda'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            children: [
              SizedBox(height: size.width * 0.05),
              DNIInputDisplayHomeInspection(
                size: size,
                tileContent: homeInspectionModel.dni,
              ),
              SizedBox(height: size.width * 0.05),
              AddressDisplayHomeInspection(
                size: size,
                address: homeInspectionModel.address,
              ),
              SizedBox(height: size.width * 0.05),
              NumberInhabitantsInputDisplayHomeInspection(
                size: size,
                tileContent: homeInspectionModel.numberinhabitants.toString(),
              ),
              SizedBox(height: size.width * 0.05),
              HomeConditionDisplayHomeInspection(
                size: size,
                homeCondition: homeInspectionModel.homecondition,
              ),
              SizedBox(height: size.width * 0.05),
              TypeContainersDisplayHomeInspection(
                size: size,
                typeContainersModel: homeInspectionModel.typecontainers,
              ),
              SizedBox(height: size.width * 0.05),
              TotalContainerDisplayHomeInspection(
                size: size,
                totalContainerModel: homeInspectionModel.totalcontainer,
              ),
              SizedBox(height: size.width * 0.05),
              AegyptiFocusDisplayHomeInspection(
                size: size,
                aegyptiFocusModel: homeInspectionModel.aegyptifocus,
              ),
              SizedBox(height: size.width * 0.05),
              LarvicideInputDisplayHomeInspection(
                size: size,
                tileContent: homeInspectionModel.larvicide.toString(),
              ),
              SizedBox(height: size.width * 0.05),
              DatetimeDisplayHomeInspection(
                size: size,
                dateTime: homeInspectionModel.datetime,
              ),
              SizedBox(height: size.width * 0.05),
              CoordinatesDisplayHomeInspection(
                size: size,
                latitude: homeInspectionModel.latitude,
                longitude: homeInspectionModel.longitude,
              ),
              SizedBox(height: size.width * 0.05),
              CommentDisplayHomeInspection(
                size: size,
                comment: homeInspectionModel.comment,
              ),
              SizedBox(height: size.width * 0.05),
              PhotoDisplayHomeInspection(
                size: size,
                photoUrl: homeInspectionModel.photourl,
              ),
              SizedBox(height: size.width * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoDisplayHomeInspection extends StatelessWidget {
  const PhotoDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.photoUrl,
  }) : super(key: key);

  final Size size;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
        child: photoUrl == 'Sin enlace'
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 75),
                child: SvgPicture.asset(
                  'assets/app_icons/no-image.svg',
                  color: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: photoUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: SvgPicture.asset(
                      'assets/app_icons/no-image.svg',
                      color:
                          ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class CommentDisplayHomeInspection extends StatelessWidget {
  const CommentDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.comment,
  }) : super(key: key);

  final Size size;
  final String comment;

  @override
  Widget build(BuildContext context) {
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
              hintStyle: TextStyle(
                color: ThemeModeApp.isDarkMode
                    ? const Color.fromARGB(255, 189, 189, 189)
                    : const Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            maxLines: 3,
            maxLength: 200,
            readOnly: true,
            controller: TextEditingController(
              text: comment,
            ),
          ),
        ],
      ),
    );
  }
}

class DatetimeDisplayHomeInspection extends StatelessWidget {
  const DatetimeDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.dateTime,
  }) : super(key: key);

  final Size size;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
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
                      DateFormat.yMMMd('es_ES').format(dateTime),
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
                      DateFormat('hh:mm:ss a').format(dateTime),
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

class CoordinatesDisplayHomeInspection extends StatelessWidget {
  const CoordinatesDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  final Size size;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
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
                      latitude.toStringAsFixed(5),
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
                      longitude.toStringAsFixed(5),
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

class AddressDisplayHomeInspection extends StatelessWidget {
  const AddressDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.address,
  }) : super(key: key);

  final Size size;
  final AddressModel address;

  @override
  Widget build(BuildContext context) {
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
          AddressRowTileDisplay(
            tileTitle: 'Cód. postal',
            tileContent: address.postalcode,
          ),
          AddressRowTileDisplay(
            tileTitle: 'País:',
            tileContent: address.country,
          ),
          AddressRowTileDisplay(
            tileTitle: 'Departamento:',
            tileContent: address.department,
          ),
          AddressRowTileDisplay(
            tileTitle: 'Provincia:',
            tileContent: address.province,
          ),
          AddressRowTileDisplay(
            tileTitle: 'Distrito:',
            tileContent: address.district,
          ),
          AddressRowTileDisplay(
            tileTitle: 'Urbanización:',
            tileContent: address.urbanization,
          ),
          AddressRowTileDisplay(
            tileTitle: 'Calle:',
            tileContent: address.street,
          ),
          AddressRowTileDisplay(
            tileTitle: 'Número:',
            tileContent: address.streetnumber.toString(),
          ),
          AddressRowTileDisplay(
            tileTitle: 'Dirección:',
            tileContent: address.formattedaddress,
          ),
          BlockInputDisplayHomeInspection(tileContent: address.block),
          LotInputDisplayHomeInspection(tileContent: address.lot.toString()),
        ],
      ),
    );
  }
}

class AddressRowTileDisplay extends StatelessWidget {
  const AddressRowTileDisplay({
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

class BlockInputDisplayHomeInspection extends StatelessWidget {
  const BlockInputDisplayHomeInspection({
    Key? key,
    required this.tileContent,
  }) : super(key: key);

  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
                readOnly: true,
                controller: TextEditingController(
                  text: tileContent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LotInputDisplayHomeInspection extends StatelessWidget {
  const LotInputDisplayHomeInspection({
    Key? key,
    required this.tileContent,
  }) : super(key: key);

  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
                readOnly: true,
                controller: TextEditingController(
                  text: tileContent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DNIInputDisplayHomeInspection extends StatelessWidget {
  const DNIInputDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.tileContent,
  }) : super(key: key);

  final Size size;
  final String tileContent;

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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class NumberInhabitantsInputDisplayHomeInspection extends StatelessWidget {
  const NumberInhabitantsInputDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.tileContent,
  }) : super(key: key);

  final Size size;
  final String tileContent;

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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeConditionDisplayHomeInspection extends StatelessWidget {
  const HomeConditionDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.homeCondition,
  }) : super(key: key);

  final Size size;
  final HomeConditionModel homeCondition;

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
          InspectedHomeInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: homeCondition.inspectedhome.toString(),
          ),
          const SizedBox(height: 20),
          ReluctantDwellingInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: homeCondition.reluctantdwelling.toString(),
          ),
          const SizedBox(height: 20),
          ClosedHomeInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: homeCondition.closedhome.toString(),
          ),
          const SizedBox(height: 20),
          UninhabitedHouseInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: homeCondition.uninhabitedhouse.toString(),
          ),
          const SizedBox(height: 20),
          HousingSpotlightsInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: homeCondition.housingspotlights.toString(),
          ),
          const SizedBox(height: 20),
          TreatedHousingInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: homeCondition.treatedhousing.toString(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class InspectedHomeInputDisplayHomeInspection extends StatelessWidget {
  const InspectedHomeInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class ReluctantDwellingInputDisplayHomeInspection extends StatelessWidget {
  const ReluctantDwellingInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class ClosedHomeInputDisplayHomeInspection extends StatelessWidget {
  const ClosedHomeInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class UninhabitedHouseInputDisplayHomeInspection extends StatelessWidget {
  const UninhabitedHouseInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class HousingSpotlightsInputDisplayHomeInspection extends StatelessWidget {
  const HousingSpotlightsInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class TreatedHousingInputDisplayHomeInspection extends StatelessWidget {
  const TreatedHousingInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class TypeContainersDisplayHomeInspection extends StatelessWidget {
  const TypeContainersDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.typeContainersModel,
  }) : super(key: key);

  final Size size;
  final TypeContainersModel typeContainersModel;

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
          ElevatedTankInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            elevatedTankModel: typeContainersModel.elevatedtank,
          ),
          const SizedBox(height: 20),
          LowTankInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            lowTankModel: typeContainersModel.lowtank,
          ),
          const SizedBox(height: 20),
          CylinderBarrelInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            cylinderBarrelModel: typeContainersModel.cylinderbarrel,
          ),
          const SizedBox(height: 20),
          BucketTubInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            bucketTubModel: typeContainersModel.buckettub,
          ),
          const SizedBox(height: 20),
          TireInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tireModel: typeContainersModel.tire,
          ),
          const SizedBox(height: 20),
          FlowerInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            flowerModel: typeContainersModel.flower,
          ),
          const SizedBox(height: 20),
          UselessInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            uselessModel: typeContainersModel.useless,
          ),
          const SizedBox(height: 20),
          OthersInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            othersModel: typeContainersModel.others,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ElevatedTankInputDisplayHomeInspection extends StatelessWidget {
  const ElevatedTankInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.elevatedTankModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final ElevatedTankModel elevatedTankModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: elevatedTankModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: elevatedTankModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: elevatedTankModel.t.toString(),
                    ),
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

class LowTankInputDisplayHomeInspection extends StatelessWidget {
  const LowTankInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.lowTankModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final LowTankModel lowTankModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: lowTankModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: lowTankModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: lowTankModel.t.toString(),
                    ),
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

class CylinderBarrelInputDisplayHomeInspection extends StatelessWidget {
  const CylinderBarrelInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.cylinderBarrelModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final CylinderBarrelModel cylinderBarrelModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: cylinderBarrelModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: cylinderBarrelModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: cylinderBarrelModel.t.toString(),
                    ),
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

class BucketTubInputDisplayHomeInspection extends StatelessWidget {
  const BucketTubInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.bucketTubModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final BucketTubModel bucketTubModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: bucketTubModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: bucketTubModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: bucketTubModel.t.toString(),
                    ),
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

class TireInputDisplayHomeInspection extends StatelessWidget {
  const TireInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tireModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final TireModel tireModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: tireModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: tireModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: tireModel.t.toString(),
                    ),
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

class FlowerInputDisplayHomeInspection extends StatelessWidget {
  const FlowerInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.flowerModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final FlowerModel flowerModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: flowerModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: flowerModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: flowerModel.t.toString(),
                    ),
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

class UselessInputDisplayHomeInspection extends StatelessWidget {
  const UselessInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.uselessModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final UselessModel uselessModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: uselessModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: uselessModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: uselessModel.t.toString(),
                    ),
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

class OthersInputDisplayHomeInspection extends StatelessWidget {
  const OthersInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.othersModel,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final OthersModel othersModel;

  @override
  Widget build(BuildContext context) {
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: othersModel.i.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: othersModel.p.toString(),
                    ),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: othersModel.t.toString(),
                    ),
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

class TotalContainerDisplayHomeInspection extends StatelessWidget {
  const TotalContainerDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.totalContainerModel,
  }) : super(key: key);

  final Size size;
  final TotalContainerModel totalContainerModel;

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
          InspectedContainersInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: totalContainerModel.inspectedcontainers.toString(),
          ),
          const SizedBox(height: 20),
          ContainersSpotlightsInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: totalContainerModel.containersspotlights.toString(),
          ),
          const SizedBox(height: 20),
          TreatedContainersInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: totalContainerModel.treatedcontainers.toString(),
          ),
          const SizedBox(height: 20),
          DestroyedContainersInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: totalContainerModel.destroyedcontainers.toString(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class InspectedContainersInputDisplayHomeInspection extends StatelessWidget {
  const InspectedContainersInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class ContainersSpotlightsInputDisplayHomeInspection extends StatelessWidget {
  const ContainersSpotlightsInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class TreatedContainersInputDisplayHomeInspection extends StatelessWidget {
  const TreatedContainersInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class DestroyedContainersInputDisplayHomeInspection extends StatelessWidget {
  const DestroyedContainersInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class AegyptiFocusDisplayHomeInspection extends StatelessWidget {
  const AegyptiFocusDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.aegyptiFocusModel,
  }) : super(key: key);

  final Size size;
  final AegyptiFocusModel aegyptiFocusModel;

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
          LarvaeInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: aegyptiFocusModel.larvae.toString(),
          ),
          const SizedBox(height: 20),
          PupaeInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: aegyptiFocusModel.pupae.toString(),
          ),
          const SizedBox(height: 20),
          AdultInputDisplayHomeInspection(
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            tileContent: aegyptiFocusModel.adult.toString(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class LarvaeInputDisplayHomeInspection extends StatelessWidget {
  const LarvaeInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class PupaeInputDisplayHomeInspection extends StatelessWidget {
  const PupaeInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class AdultInputDisplayHomeInspection extends StatelessWidget {
  const AdultInputDisplayHomeInspection({
    Key? key,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.tileContent,
  }) : super(key: key);

  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder focusedBorder;
  final String tileContent;

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}

class LarvicideInputDisplayHomeInspection extends StatelessWidget {
  const LarvicideInputDisplayHomeInspection({
    Key? key,
    required this.size,
    required this.tileContent,
  }) : super(key: key);

  final Size size;
  final String tileContent;

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
            readOnly: true,
            controller: TextEditingController(
              text: tileContent,
            ),
          ),
        ),
      ],
    );
  }
}
