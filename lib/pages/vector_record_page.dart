import 'package:cached_network_image/cached_network_image.dart';
import 'package:denv_mobile/models/models.dart';
import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

class VectorRecordPage extends StatelessWidget {
  const VectorRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final vectorRecordModel =
        ModalRoute.of(context)!.settings.arguments as VectorRecordModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del registro del vector'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            PhotoDisplayVectorRecord(
              size: size,
              photoUrl: vectorRecordModel.photourl,
            ),
            const SizedBox(height: 30),
            CommentDisplayVectorRecord(
              size: size,
              comment: vectorRecordModel.comment,
            ),
            const SizedBox(height: 20),
            DatetimeDisplayVectorRecord(
              size: size,
              dateTime: vectorRecordModel.datetime,
            ),
            const SizedBox(height: 30),
            CoordinatesDisplayVectorRecord(
              size: size,
              latitude: vectorRecordModel.latitude,
              longitude: vectorRecordModel.longitude,
            ),
            const SizedBox(height: 30),
            AddressDisplayVectorRecord(
              size: size,
              address: vectorRecordModel.address.formattedaddress,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PhotoDisplayVectorRecord extends StatelessWidget {
  const PhotoDisplayVectorRecord({
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

class CommentDisplayVectorRecord extends StatelessWidget {
  const CommentDisplayVectorRecord({
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

class DatetimeDisplayVectorRecord extends StatelessWidget {
  const DatetimeDisplayVectorRecord({
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

class CoordinatesDisplayVectorRecord extends StatelessWidget {
  const CoordinatesDisplayVectorRecord({
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

class AddressDisplayVectorRecord extends StatelessWidget {
  const AddressDisplayVectorRecord({
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
