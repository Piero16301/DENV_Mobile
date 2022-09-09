import 'dart:convert';

import 'package:denv_mobile/models/inspection/containers/containers.dart';

TypeContainersModel typeContainersModelFromJson(String str) =>
    TypeContainersModel.fromJson(json.decode(str));
String typeContainersModelToJson(TypeContainersModel data) =>
    json.encode(data.toJson());

class TypeContainersModel {
  ElevatedTankModel elevatedtank;
  LowTankModel lowtank;
  CylinderBarrelModel cylinderbarrel;
  BucketTubModel buckettub;
  TireModel tire;
  FlowerModel flower;
  UselessModel useless;
  OthersModel others;

  TypeContainersModel({
    required this.elevatedtank,
    required this.lowtank,
    required this.cylinderbarrel,
    required this.buckettub,
    required this.tire,
    required this.flower,
    required this.useless,
    required this.others,
  });

  factory TypeContainersModel.fromJson(Map<String, dynamic> json) =>
      TypeContainersModel(
        elevatedtank: ElevatedTankModel.fromJson(json["elevatedtank"]),
        lowtank: LowTankModel.fromJson(json["lowtank"]),
        cylinderbarrel: CylinderBarrelModel.fromJson(json["cylinderbarrel"]),
        buckettub: BucketTubModel.fromJson(json["buckettub"]),
        tire: TireModel.fromJson(json["tire"]),
        flower: FlowerModel.fromJson(json["flower"]),
        useless: UselessModel.fromJson(json["useless"]),
        others: OthersModel.fromJson(json["others"]),
      );

  Map<String, dynamic> toJson() => {
        "elevatedtank": elevatedtank.toJson(),
        "lowtank": lowtank.toJson(),
        "cylinderbarrel": cylinderbarrel.toJson(),
        "buckettub": buckettub.toJson(),
        "tire": tire.toJson(),
        "flower": flower.toJson(),
        "useless": useless.toJson(),
        "others": others.toJson(),
      };
}
