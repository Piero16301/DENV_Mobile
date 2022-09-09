import 'dart:convert';

FlowerModel flowerModelFromJson(String str) =>
    FlowerModel.fromJson(json.decode(str));
String flowerModelToJson(FlowerModel data) => json.encode(data.toJson());

class FlowerModel {
  int i;
  int p;
  int t;

  FlowerModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory FlowerModel.fromJson(Map<String, dynamic> json) => FlowerModel(
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
