import 'dart:convert';

ElevatedTankModel elevatedTankModelFromJson(String str) =>
    ElevatedTankModel.fromJson(json.decode(str));
String elevatedTankModelToJson(ElevatedTankModel data) =>
    json.encode(data.toJson());

class ElevatedTankModel {
  int i;
  int p;
  int t;

  ElevatedTankModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory ElevatedTankModel.fromJson(Map<String, dynamic> json) =>
      ElevatedTankModel(
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
