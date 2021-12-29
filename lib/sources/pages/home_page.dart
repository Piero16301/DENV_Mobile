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
      getCity(latitude: currentPosition.latitude, longitude: currentPosition.longitude).then((currentCity) {
        currentcity = currentCity;

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
      body: Container(
        width: _size.width,
        height: _size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0f2027),
              Color(0xff203a43),
              Color(0xff2c5364),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.0, 1.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Zona de Ver Mapa
            InkWell(
              onTap: () => Navigator.pushNamed(context, 'view_map'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GIF de carga de mapa
                  Center(
                    child: Image.asset(
                      'assets/main-loading.gif',
                      height: 170,
                      width: 170,
                    ),
                  ),

                  SizedBox(
                    height: _size.height * 0.025,
                  ),

                  // Texto de mostrar mapa
                  const Center(
                    child: Text(
                      'VER MAPA',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  ),
                ],
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
                  'REPORTAR ÁREA CON MOSQUITOS',
                  'report_area',
                ),

                homePageButton(
                  _size,
                  'SUBIR FOTO DE MOSQUITO',
                  'report_area',
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
                  Icons.location_on_outlined,
                  color: Colors.white,
                ),

                SizedBox(
                  width: _size.width * 0.03,
                ),

                Text(
                  '$currentcity, $_currentDate',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SizedBox homePageButton(Size _size, String text, String page) {
    return SizedBox(
      height: _size.height * 0.105,
      width: _size.width * 0.31,
      child: Column(
        children: [
          ElevatedButton(
            child: Container(),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              elevation: MaterialStateProperty.all<double>(3.0),
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff2c5364)),
              minimumSize: MaterialStateProperty.all<Size>(Size(_size.width * 0.31, _size.height * 0.05)),
            ),
            onPressed: () => Navigator.pushNamed(context, page),
          ),

          const Spacer(),

          Text(
            text,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          )
        ],
      ),
    );
  }
}

