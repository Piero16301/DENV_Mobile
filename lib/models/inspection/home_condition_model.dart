import 'dart:convert';

HomeConditionModel homeConditionModelFromJson(String str) =>
    HomeConditionModel.fromJson(json.decode(str));
String homeConditionModelToJson(HomeConditionModel data) =>
    json.encode(data.toJson());

class HomeConditionModel {
  int inspectedhome;
  int reluctantdwelling;
  int closedhome;
  int uninhabitedhouse;
  int housingspotlights;
  int treatedhousing;

  HomeConditionModel({
    required this.inspectedhome,
    required this.reluctantdwelling,
    required this.closedhome,
    required this.uninhabitedhouse,
    required this.housingspotlights,
    required this.treatedhousing,
  });

  factory HomeConditionModel.fromJson(Map<String, dynamic> json) =>
      HomeConditionModel(
        inspectedhome: json["inspectedhome"],
        reluctantdwelling: json["reluctantdwelling"],
        closedhome: json["closedhome"],
        uninhabitedhouse: json["uninhabitedhouse"],
        housingspotlights: json["housingspotlights"],
        treatedhousing: json["treatedhousing"],
      );

  Map<String, dynamic> toJson() => {
        "inspectedhome": inspectedhome,
        "reluctantdwelling": reluctantdwelling,
        "closedhome": closedhome,
        "uninhabitedhouse": uninhabitedhouse,
        "housingspotlights": housingspotlights,
        "treatedhousing": treatedhousing,
      };
}
