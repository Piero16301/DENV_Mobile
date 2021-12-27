import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:deteccion_zonas_dengue/sources/providers/location_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentcity = '-';

  @override
  void initState() {
    super.initState();

    getCurrentLocation().then((currentPosition) {
      getDirection(latitude: currentPosition.latitude, longitude: currentPosition.longitude).then((currentAddress) {
        if (currentAddress.city != null) {
          currentcity = currentAddress.city!;
        } else {
          currentcity = '-';
        }
        setState(() {});
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final String _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GIF de mostrar mapa
            const Center(
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 170,
              ),
            ),

            // Texto de mostrar mapa
            const Center(
              child: Text(
                'VER MAPA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white
                ),
              ),
            ),

            // Espacio hacia los botones
            SizedBox(
              height: _size.height * 0.1,
            ),

            // Fila con los botones principales
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                homePageButton(
                  _size,
                  'REPORTAR ÁREA CON MOSQUITOS'
                ),

                homePageButton(
                  _size,
                  'SUBIR FOTO DE MOSQUITO'
                ),
              ],
            ),

            // Espacio hacia los botones
            SizedBox(
              height: _size.height * 0.1,
            ),

            // Texto con la ubicación y fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined
                ),

                SizedBox(
                  width: _size.width * 0.03,
                ),

                Text(
                  '$currentcity, $_currentDate',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SizedBox homePageButton(Size _size, String text) {
    return SizedBox(
      height: _size.height * 0.105,
      width: _size.width * 0.31,
      child: Column(
        children: [
          Container(
            height: _size.height * 0.05,
            width: _size.width * 0.31,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green,
            ),
          ),

          const Spacer(),

          Text(
            text,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}

