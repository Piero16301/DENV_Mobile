import 'dart:convert';

MosquitoPointResponse mosquitoPointResponseFromJson(String str) => MosquitoPointResponse.fromJson(json.decode(str));
String mosquitoPointResponseToJson(MosquitoPointResponse data) => json.encode(data.toJson());

class MosquitoPointResponse {
  MosquitoPointResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  int status;
  String message;
  MosquitoPointData data;

  factory MosquitoPointResponse.fromJson(Map<String, dynamic> json) => MosquitoPointResponse(
    status : json['status'],
    message: json['message'],
    data   : MosquitoPointData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message': message,
    'data'   : data.toJson(),
  };
}

MosquitoPointData mosquitoPointDataFromJson(String str) => MosquitoPointData.fromJson(json.decode(str));
String mosquitoPointDataToJson(MosquitoPointData data) => json.encode(data.toJson());

class MosquitoPointData {
  MosquitoPointData({
    required this.data,
  });

  List<MosquitoPointModel> data;

  factory MosquitoPointData.fromJson(Map<String, dynamic> json) => MosquitoPointData(
    data: List<MosquitoPointModel>.from(json['data'].map((x) => MosquitoPointModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'data' : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

MosquitoPointModel mosquitoPointModelFromJson(String str) => MosquitoPointModel.fromJson(json.decode(str));
String mosquitoPointModelToJson(MosquitoPointModel data) => json.encode(data.toJson());

class MosquitoPointModel {
  String id;
  String address;
  String comment;
  DateTime datetime;
  double latitude;
  double longitude;
  String photourl;

  MosquitoPointModel({
    this.id = '',
    required this.address,
    required this.comment,
    required this.datetime,
    required this.latitude,
    required this.longitude,
    required this.photourl,
  });

  factory MosquitoPointModel.fromJson(Map<String, dynamic> json) => MosquitoPointModel(
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
