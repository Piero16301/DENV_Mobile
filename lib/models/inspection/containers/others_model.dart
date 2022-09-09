import 'dart:convert';

OthersModel othersModelFromJson(String str) =>
    OthersModel.fromJson(json.decode(str));
String othersModelToJson(OthersModel data) => json.encode(data.toJson());

class OthersModel {
  int i;
  int p;
  int t;

  OthersModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory OthersModel.fromJson(Map<String, dynamic> json) => OthersModel(
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
