import 'dart:convert';

MosquitoPointModel mosquitoPointFromJson(String str) => MosquitoPointModel.fromJson(json.decode(str));

String mosquitoPointToJson(MosquitoPointModel data) => json.encode(data.toJson());

class MosquitoPointModel {
  String id;
  String comentario;
  String direccion;
  String fecha;
  String fotoUrl;
  String hora;
  double latitud;
  double longitud;

  MosquitoPointModel({
    this.id         = '',
    this.comentario = '',
    this.direccion  = '',
    this.fecha      = '',
    this.fotoUrl    = '',
    this.hora       = '',
    this.latitud    = 0.0,
    this.longitud   = 0.0,
  });

  factory MosquitoPointModel.fromJson(Map<String, dynamic> json) => MosquitoPointModel(
    comentario: json['comentario'],
    direccion:  json['direccion'],
    fecha:      json['fecha'],
    fotoUrl:    json['fotoUrl'],
    hora:       json['hora'],
    latitud:    json['latitud'].toDouble(),
    longitud:   json['longitud'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'comentario': comentario,
    'direccion' : direccion,
    'fecha'     : fecha,
    'fotoUrl'   : 'Sin enlace',
    'hora'      : hora,
    'latitud'   : latitud,
    'longitud'  : longitud,
  };
}
