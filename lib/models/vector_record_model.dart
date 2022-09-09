import 'package:denv_mobile/models/models.dart';

class VectorRecordModel {
  String? id;
  AddressModel address;
  String comment;
  DateTime datetime;
  double latitude;
  double longitude;
  String photourl;

  VectorRecordModel({
    this.id,
    required this.address,
    required this.comment,
    required this.datetime,
    required this.latitude,
    required this.longitude,
    required this.photourl,
  });

  factory VectorRecordModel.fromJson(Map<String, dynamic> json) =>
      VectorRecordModel(
        id: json["id"],
        address: AddressModel.fromJson(json["address"]),
        comment: json["comment"],
        datetime: DateTime.parse(json["datetime"]),
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        photourl: json["photourl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address.toJson(),
        "comment": comment,
        "datetime": parseDateTime(),
        "latitude": latitude,
        "longitude": longitude,
        "photourl": photourl,
      };

  String parseDateTime() {
    return '${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}T${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}:${datetime.second.toString().padLeft(2, '0')}.000+00:00';
  }
}
