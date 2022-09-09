import 'dart:convert';

BucketTubModel bucketTubModelFromJson(String str) =>
    BucketTubModel.fromJson(json.decode(str));
String bucketTubModelToJson(BucketTubModel data) => json.encode(data.toJson());

class BucketTubModel {
  int i;
  int p;
  int t;

  BucketTubModel({
    required this.i,
    required this.p,
    required this.t,
  });

  factory BucketTubModel.fromJson(Map<String, dynamic> json) => BucketTubModel(
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
