import 'dart:convert';

import 'package:denv_mobile/models/inspection/inspection.dart';
import 'package:denv_mobile/models/models.dart';

HomeInspectionModel caseReportModelFromJson(String str) =>
    HomeInspectionModel.fromJson(json.decode(str));
String caseReportModelToJson(HomeInspectionModel data) =>
    json.encode(data.toJson());

class HomeInspectionModel {
  String? id;
  AddressModel address;
  String comment;
  DateTime datetime;
  String dni;
  double latitude;
  double longitude;
  String photourl;

  int numberinhabitants;
  HomeConditionModel homecondition;
  TypeContainersModel typecontainers;
  TotalContainerModel totalcontainer;
  AegyptiFocusModel aegyptifocus;

  HomeInspectionModel({
    this.id,
    required this.address,
    required this.comment,
    required this.datetime,
    required this.dni,
    required this.latitude,
    required this.longitude,
    required this.photourl,
    required this.numberinhabitants,
    required this.homecondition,
    required this.typecontainers,
    required this.totalcontainer,
    required this.aegyptifocus,
  });

  factory HomeInspectionModel.fromJson(Map<String, dynamic> json) =>
      HomeInspectionModel(
        id: json["id"],
        address: AddressModel.fromJson(json["address"]),
        comment: json["comment"],
        datetime: DateTime.parse(json["datetime"]),
        dni: json["dni"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        photourl: json["photourl"],
        numberinhabitants: json["numberinhabitants"],
        homecondition: HomeConditionModel.fromJson(json["homecondition"]),
        typecontainers: TypeContainersModel.fromJson(json["typecontainers"]),
        totalcontainer: TotalContainerModel.fromJson(json["totalcontainer"]),
        aegyptifocus: AegyptiFocusModel.fromJson(json["aegyptifocus"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address.toJson(),
        "comment": comment,
        "datetime": parseDateTime(),
        "dni": dni,
        "latitude": latitude,
        "longitude": longitude,
        "photourl": photourl,
        "numberinhabitants": numberinhabitants,
        "homecondition": homecondition.toJson(),
        "typecontainers": typecontainers.toJson(),
        "totalcontainer": totalcontainer.toJson(),
        "aegyptifocus": aegyptifocus.toJson(),
      };

  String parseDateTime() {
    return '${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}T${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}:${datetime.second.toString().padLeft(2, '0')}.000+00:00';
  }
}
