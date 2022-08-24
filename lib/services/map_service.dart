import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class MapService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://20.206.152.104',
      contentType: 'application/json',
    ),
  );

  bool isGettingCaseReports = false;
  bool isGettingPropagationZones = false;

  Future<List<CaseReportSummarizedModel>> getCaseReportsSummarized() async {
    try {
      isGettingCaseReports = true;
      notifyListeners();
      final response = await _dio.get('/case-reports-summarized');
      if (response.statusCode == 200) {
        isGettingCaseReports = false;
        notifyListeners();
        return (response.data['data'] as List<dynamic>)
            .map((e) => CaseReportSummarizedModel.fromJson(e))
            .toList();
      } else {
        isGettingCaseReports = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      isGettingCaseReports = false;
      notifyListeners();
      return [];
    }
  }

  Future<List<PropagationZoneSummarizedModel>>
      getPropagationZonesSummarized() async {
    try {
      isGettingPropagationZones = true;
      notifyListeners();
      final response = await _dio.get('/propagation-zones-summarized');
      if (response.statusCode == 200) {
        isGettingPropagationZones = false;
        notifyListeners();
        return (response.data['data'] as List<dynamic>)
            .map((e) => PropagationZoneSummarizedModel.fromJson(e))
            .toList();
      } else {
        isGettingPropagationZones = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      isGettingPropagationZones = false;
      notifyListeners();
      return [];
    }
  }
}
