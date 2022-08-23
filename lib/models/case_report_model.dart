import 'dart:convert';

import 'package:denv_mobile/models/models.dart';

CaseReportModel caseReportModelFromJson(String str) =>
    CaseReportModel.fromJson(json.decode(str));
String caseReportModelToJson(CaseReportModel data) =>
    json.encode(data.toJson());

class CaseReportModel {
  String? id;
  AddressModel address;
  String comment;
  DateTime dateTime;
  double latitude;
  double longitude;
  String photoUrl;

  CaseReportModel({
    this.id,
    required this.address,
    required this.comment,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.photoUrl,
  });

  factory CaseReportModel.fromJson(Map<String, dynamic> json) =>
      CaseReportModel(
        id: json["id"],
        address: AddressModel.fromJson(json["address"]),
        comment: json["comment"],
        dateTime: DateTime.parse(json["datetime"]),
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        photoUrl: json["photo_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address.toJson(),
        "comment": comment,
        "datetime": parseDateTime(),
        "latitude": latitude,
        "longitude": longitude,
        "photo_url": photoUrl,
      };

  String parseDateTime() {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}T${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}.000+00:00';
  }
}
