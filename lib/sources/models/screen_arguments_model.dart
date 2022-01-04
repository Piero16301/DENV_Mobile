import 'package:deteccion_zonas_dengue/sources/models/mosquito_photo_model.dart';
import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';

class ScreenArguments {
  final List<MosquitoPointModel> listMosquitoPoints;
  final List<MosquitoPhotoModel> listMosquitoPhotos;

  final double centerLatitude;
  final double centerLongitude;

  ScreenArguments(
      this.listMosquitoPoints,
      this.listMosquitoPhotos,
      this.centerLatitude,
      this.centerLongitude,
      );
}