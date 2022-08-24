import 'dart:convert';

CaseReportSummarizedModel caseReportSummarizedModelFromJson(String str) =>
    CaseReportSummarizedModel.fromJson(json.decode(str));
String caseReportSummarizedModelToJson(CaseReportSummarizedModel data) =>
    json.encode(data.toJson());

class CaseReportSummarizedModel {
  String id;
  double latitude;
  double longitude;

  CaseReportSummarizedModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory CaseReportSummarizedModel.fromJson(Map<String, dynamic> json) =>
      CaseReportSummarizedModel(
        id: json["id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
      };
}
