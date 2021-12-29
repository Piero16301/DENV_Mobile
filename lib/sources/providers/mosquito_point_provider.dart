import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:deteccion_zonas_dengue/sources/models/mosquito_point_model.dart';

class MosquitoPointProvider {
  final String _url = 'https://deteccion-zonas-dengue-default-rtdb.firebaseio.com';

  Future<bool> createMosquitoPoint(MosquitoPointModel mosquitoPoint) async {
    final url = '$_url/puntos-mosquitos.json';
    final response = await http.post(Uri.parse(url), body: mosquitoPointToJson(mosquitoPoint));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MosquitoPointModel>> getAllMosquitoPoints() async {
    final url = '$_url/puntos-mosquitos.json';
    final response = await http.get(Uri.parse(url));

    final Map<String, dynamic>? decodedData = json.decode(response.body);
    final List<MosquitoPointModel> points = [];

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, point) {
      final pointTemp = MosquitoPointModel.fromJson(point);
      pointTemp.id = id;
      points.add(pointTemp);
    });

    return points;
  }
}