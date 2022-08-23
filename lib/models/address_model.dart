import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));
String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  String formattedAddress;
  String postalCode;
  String country;
  String department;
  String province;
  String district;
  String urbanization;
  String street;
  int streetNumber;

  AddressModel({
    required this.formattedAddress,
    required this.postalCode,
    required this.country,
    required this.department,
    required this.province,
    required this.district,
    required this.urbanization,
    required this.street,
    required this.streetNumber,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        formattedAddress: json["formatted_address"],
        postalCode: json["postalCode"],
        country: json["country"],
        department: json["department"],
        province: json["province"],
        district: json["district"],
        urbanization: json["urbanization"],
        street: json["street"],
        streetNumber: json["streetNumber"],
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "postalCode": postalCode,
        "country": country,
        "department": department,
        "province": province,
        "district": district,
        "urbanization": urbanization,
        "street": street,
        "streetNumber": streetNumber,
      };
}
