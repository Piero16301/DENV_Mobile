import 'dart:convert';

VectorRecordSummarizedModel vectorRecordSummarizedModelFromJson(String str) =>
    VectorRecordSummarizedModel.fromJson(json.decode(str));
String vectorRecordSummarizedModelToJson(VectorRecordSummarizedModel data) =>
    json.encode(data.toJson());

class VectorRecordSummarizedModel {
  String id;
  double latitude;
  double longitude;

  VectorRecordSummarizedModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory VectorRecordSummarizedModel.fromJson(Map<String, dynamic> json) =>
      VectorRecordSummarizedModel(
        id: json["id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
      };
}
