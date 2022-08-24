import 'dart:convert';

PropagationZoneSummarizedModel propagationZoneSummarizedModelFromJson(
        String str) =>
    PropagationZoneSummarizedModel.fromJson(json.decode(str));
String propagationZoneSummarizedModelToJson(
        PropagationZoneSummarizedModel data) =>
    json.encode(data.toJson());

class PropagationZoneSummarizedModel {
  String id;
  double latitude;
  double longitude;

  PropagationZoneSummarizedModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory PropagationZoneSummarizedModel.fromJson(Map<String, dynamic> json) =>
      PropagationZoneSummarizedModel(
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
