import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';

class MosquitoPointProvider {
  // URL Backend
  final String _url = 'http://40.124.84.39';

  Future<bool> createMosquitoPoint(MosquitoPointModel mosquitoPoint) async {
    final url = '$_url/point';
    final response = await http.post(Uri.parse(url), body: mosquitoPointModelToJson(mosquitoPoint));
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return false;

    if (decodedData["message"] == "success") {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MosquitoPointModel>> getAllMosquitoPoints() async {
    final url = '$_url/points';
    final response = await http.get(Uri.parse(url));

    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return [];

    if (decodedData['message'] != "success") return [];

    final mosquitoPointResponse = MosquitoPointResponse.fromJson(decodedData);

    return mosquitoPointResponse.data.data;
  }
}