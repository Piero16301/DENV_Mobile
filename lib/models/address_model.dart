import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));
String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  String formattedaddress;
  String postalcode;
  String country;
  String department;
  String province;
  String district;
  String urbanization;
  String street;
  String block;
  int lot;
  int streetnumber;

  AddressModel({
    required this.formattedaddress,
    required this.postalcode,
    required this.country,
    required this.department,
    required this.province,
    required this.district,
    required this.urbanization,
    required this.street,
    required this.block,
    required this.lot,
    required this.streetnumber,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        formattedaddress: json["formattedaddress"],
        postalcode: json["postalcode"],
        country: json["country"],
        department: json["department"],
        province: json["province"],
        district: json["district"],
        urbanization: json["urbanization"],
        street: json["street"],
        block: json["block"],
        lot: json["lot"],
        streetnumber: json["streetnumber"],
      );

  Map<String, dynamic> toJson() => {
        "formattedaddress": formattedaddress,
        "postalcode": postalcode,
        "country": country,
        "department": department,
        "province": province,
        "district": district,
        "urbanization": urbanization,
        "street": street,
        "block": block,
        "lot": lot,
        "streetnumber": streetnumber,
      };
}
