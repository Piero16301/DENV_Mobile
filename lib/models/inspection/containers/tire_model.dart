import 'dart:convert';

TireModel tireModelFromJson(String str) => TireModel.fromJson(json.decode(str));
String tireModelToJson(TireModel data) => json.encode(data.toJson());

class TireModel {
  int i;
  int p;
  int t;

  TireModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory TireModel.fromJson(Map<String, dynamic> json) => TireModel(
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
