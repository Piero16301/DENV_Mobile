import 'package:cached_network_image/cached_network_image.dart';
import 'package:denv_mobile/models/models.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

class PropagationZonePage extends StatelessWidget {
  const PropagationZonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final propagationZoneModel =
        ModalRoute.of(context)!.settings.arguments as PropagationZoneModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la zona de propagación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            PhotoDisplayPropagationZone(
              size: size,
              photoUrl: propagationZoneModel.photoUrl,
            ),
            const SizedBox(height: 30),
            CommentDisplayPropagationZone(
              size: size,
              comment: propagationZoneModel.comment,
            ),
            const SizedBox(height: 20),
            DatetimeDisplayPropagationZone(
              size: size,
              dateTime: propagationZoneModel.dateTime,
            ),
            const SizedBox(height: 30),
            CoordinatesDisplayPropagationZone(
              size: size,
              latitude: propagationZoneModel.latitude,
              longitude: propagationZoneModel.longitude,
            ),
            const SizedBox(height: 30),
            AddressDisplayPropagationZone(
              size: size,
              address: propagationZoneModel.address.formattedAddress,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PhotoDisplayPropagationZone extends StatelessWidget {
  const PhotoDisplayPropagationZone({
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

class CommentDisplayPropagationZone extends StatelessWidget {
  const CommentDisplayPropagationZone({
    Key? key,
    required this.size,
    required this.comment,
  }) : super(key: key);

  final Size size;
  final String comment;

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

class DatetimeDisplayPropagationZone extends StatelessWidget {
  const DatetimeDisplayPropagationZone({
    Key? key,
    required this.size,
    required this.dateTime,
  }) : super(key: key);

  final Size size;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
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

class CoordinatesDisplayPropagationZone extends StatelessWidget {
  const CoordinatesDisplayPropagationZone({
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

class AddressDisplayPropagationZone extends StatelessWidget {
  const AddressDisplayPropagationZone({
    Key? key,
    required this.size,
    required this.address,
  }) : super(key: key);

  final Size size;
  final String address;

  @override
  Widget build(BuildContext context) {
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
                      address,
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
