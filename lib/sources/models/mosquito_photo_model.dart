import 'dart:convert';

MosquitoPhotoResponse mosquitoPhotoResponseFromJson(String str) => MosquitoPhotoResponse.fromJson(json.decode(str));
String mosquitoPhotoResponseToJson(MosquitoPhotoResponse data) => json.encode(data.toJson());

class MosquitoPhotoResponse {
  MosquitoPhotoResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  int status;
  String message;
  MosquitoPhotoData data;

  factory MosquitoPhotoResponse.fromJson(Map<String, dynamic> json) => MosquitoPhotoResponse(
    status : json['status'],
    message: json['message'],
    data   : MosquitoPhotoData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message': message,
    'data'   : data.toJson(),
  };
}

MosquitoPhotoData mosquitoPhotoDataFromJson(String str) => MosquitoPhotoData.fromJson(json.decode(str));
String mosquitoPhotoDataToJson(MosquitoPhotoData data) => json.encode(data.toJson());

class MosquitoPhotoData {
  MosquitoPhotoData({
    required this.data,
  });

  List<MosquitoPhotoModel> data;

  factory MosquitoPhotoData.fromJson(Map<String, dynamic> json) => MosquitoPhotoData(
    data: List<MosquitoPhotoModel>.from(json['data'].map((x) => MosquitoPhotoModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

MosquitoPhotoModel mosquitoPhotoFromJson(String str) => MosquitoPhotoModel.fromJson(json.decode(str));
String mosquitoPhotoToJson(MosquitoPhotoModel data) => json.encode(data.toJson());

class MosquitoPhotoModel {
  String id;
  String address;
  String comment;
  DateTime datetime;
  double latitude;
  double longitude;
  String photourl;

  MosquitoPhotoModel({
    this.id = '',
    required this.address,
    required this.comment,
    required this.datetime,
    required this.latitude,
    required this.longitude,
    required this.photourl,
  });

  factory MosquitoPhotoModel.fromJson(Map<String, dynamic> json) => MosquitoPhotoModel(
    id       : json['id'],
    address  : json['address'],
    comment  : json['comment'],
    datetime : DateTime.parse(json['datetime']),
    latitude : json['latitude'].toDouble(),
    longitude: json['longitude'].toDouble(),
    photourl : json['photourl'],
  );

  Map<String, dynamic> toJson() => {
    'id'       : id,
    'address'  : address,
    'comment'  : comment,
    'datetime' : datetime.toIso8601String(),
    'latitude' : latitude,
    'longitude': longitude,
    'photourl' : photourl,
  };
}
