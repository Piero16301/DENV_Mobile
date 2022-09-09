import 'dart:convert';

HomeInspectionSummarizedModel homeInspectionSummarizedModelFromJson(
        String str) =>
    HomeInspectionSummarizedModel.fromJson(json.decode(str));
String homeInspectionSummarizedModelToJson(
        HomeInspectionSummarizedModel data) =>
    json.encode(data.toJson());

class HomeInspectionSummarizedModel {
  String id;
  double latitude;
  double longitude;

  HomeInspectionSummarizedModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory HomeInspectionSummarizedModel.fromJson(Map<String, dynamic> json) =>
      HomeInspectionSummarizedModel(
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
