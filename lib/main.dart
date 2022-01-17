import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:deteccion_zonas_dengue/sources/pages/pages.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DENV',
      initialRoute: 'home',
      routes: {
        'home'                : (BuildContext context) => const HomePage(),
        'view_map'            : (BuildContext context) => const ViewMapPage(),
        'report_area'         : (BuildContext context) => const ReportAreaPage(),
        'report_area_comment' : (BuildContext context) => const ReportAreaComment(),
        'get_image'           : (BuildContext context) => const GetImagePage(),
        'upload_image'        : (BuildContext context) => const UploadImagePage(),
        'mosquito_point_view' : (BuildContext context) => const MosquitoPointViewPage(),
        'mosquito_photo_view' : (BuildContext context) => const MosquitoPhotoView(),
      },
      builder: EasyLoading.init(),
    );
  }
}
