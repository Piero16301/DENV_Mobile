import 'dart:convert';

TotalContainerModel totalContainerModelFromJson(String str) =>
    TotalContainerModel.fromJson(json.decode(str));
String totalContainerModelToJson(TotalContainerModel data) =>
    json.encode(data.toJson());

class TotalContainerModel {
  int inspectedcontainers;
  int containersspotlights;
  int treatedcontainers;
  int destroyedcontainers;

  TotalContainerModel({
    required this.inspectedcontainers,
    required this.containersspotlights,
    required this.treatedcontainers,
    required this.destroyedcontainers,
  });

  factory TotalContainerModel.fromJson(Map<String, dynamic> json) =>
      TotalContainerModel(
        inspectedcontainers: json["inspectedcontainers"],
        containersspotlights: json["containersspotlights"],
        treatedcontainers: json["treatedcontainers"],
        destroyedcontainers: json["destroyedcontainers"],
      );

  Map<String, dynamic> toJson() => {
        "inspectedcontainers": inspectedcontainers,
        "containersspotlights": containersspotlights,
        "treatedcontainers": treatedcontainers,
        "destroyedcontainers": destroyedcontainers,
      };
}
