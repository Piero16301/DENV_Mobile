import 'dart:convert';

MosquitoPointModel mosquitoPointFromJson(String str) => MosquitoPointModel.fromJson(json.decode(str));

String mosquitoPointToJson(MosquitoPointModel data) => json.encode(data.toJson());

class MosquitoPointModel {
  String id;
  String comentario;
  double latitud;
  double longitud;

  MosquitoPointModel({
    this.id         = '',
    this.comentario = '',
    this.latitud    = 0.0,
    this.longitud   = 0.0,
  });

  factory MosquitoPointModel.fromJson(Map<String, dynamic> json) => MosquitoPointModel(
    comentario: json['comentario'],
    latitud:    json['latitud'].toDouble(),
    longitud:   json['longitud'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'comentario': comentario,
    'latitud'   : latitud,
    'longitud'  : longitud,
  };
}
