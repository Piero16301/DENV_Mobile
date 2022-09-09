import 'dart:convert';

AegyptiFocusModel aegyptiFocusModelFromJson(String str) =>
    AegyptiFocusModel.fromJson(json.decode(str));
String aegyptiFocusModelToJson(AegyptiFocusModel data) =>
    json.encode(data.toJson());

class AegyptiFocusModel {
  int larvae;
  int pupae;
  int adult;

  AegyptiFocusModel({
    required this.larvae,
    required this.pupae,
    required this.adult,
  });

  factory AegyptiFocusModel.fromJson(Map<String, dynamic> json) =>
      AegyptiFocusModel(
        larvae: json["larvae"],
        pupae: json["pupae"],
        adult: json["adult"],
      );

  Map<String, dynamic> toJson() => {
        "larvae": larvae,
        "pupae": pupae,
        "adult": adult,
      };
}
