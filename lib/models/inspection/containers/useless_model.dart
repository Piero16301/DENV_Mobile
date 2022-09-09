import 'dart:convert';

UselessModel uselessModelFromJson(String str) =>
    UselessModel.fromJson(json.decode(str));
String uselessModelToJson(UselessModel data) => json.encode(data.toJson());

class UselessModel {
  int i;
  int p;
  int t;

  UselessModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory UselessModel.fromJson(Map<String, dynamic> json) => UselessModel(
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
