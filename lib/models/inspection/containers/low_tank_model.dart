import 'dart:convert';

LowTankModel lowTankModelFromJson(String str) =>
    LowTankModel.fromJson(json.decode(str));
String lowTankModelToJson(LowTankModel data) => json.encode(data.toJson());

class LowTankModel {
  int i;
  int p;
  int t;

  LowTankModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory LowTankModel.fromJson(Map<String, dynamic> json) => LowTankModel(
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
