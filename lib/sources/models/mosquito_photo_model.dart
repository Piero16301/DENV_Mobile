import 'dart:convert';

MosquitoPhotoModel mosquitoPointFromJson(String str) => MosquitoPhotoModel.fromJson(json.decode(str));

String mosquitoPointToJson(MosquitoPhotoModel data) => json.encode(data.toJson());

class MosquitoPhotoModel {
  String id;
  String direccion;
  String fecha;
  String fotoUrl;
  String hora;
  double latitud;
  double longitud;

  MosquitoPhotoModel({
    this.id         = '',
    this.direccion  = '',
    this.fecha      = '',
    this.fotoUrl    = '',
    this.hora       = '',
    this.latitud    = 0.0,
    this.longitud   = 0.0,
  });

  factory MosquitoPhotoModel.fromJson(Map<String, dynamic> json) => MosquitoPhotoModel(
    direccion : json['direccion'],
    fecha     : json['fecha'],
    fotoUrl   : json['fotoUrl'],
    hora      : json['hora'],
    latitud   : json['latitud'].toDouble(),
    longitud  : json['longitud'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'direccion' : direccion,
    'fecha'     : fecha,
    'fotoUrl'   : fotoUrl,
    'hora'      : hora,
    'latitud'   : latitud,
    'longitud'  : longitud,
  };
}