import 'dart:convert';

CylinderBarrelModel cylinderBarrelModelFromJson(String str) =>
    CylinderBarrelModel.fromJson(json.decode(str));
String cylinderBarrelModelToJson(CylinderBarrelModel data) =>
    json.encode(data.toJson());

class CylinderBarrelModel {
  int i;
  int p;
  int t;

  CylinderBarrelModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory CylinderBarrelModel.fromJson(Map<String, dynamic> json) =>
      CylinderBarrelModel(
        i: json["i"],
        p: json["p"],
        t: json["t"],
      );

  Map<String, dynamic> toJson() => {
        "i": i,
        "p": p,
        "t": t,
      };
}
