import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class MapService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://20.206.152.104',
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
      connectTimeout: 3 * 1000,
      receiveTimeout: 3 * 1000,
    ),
  );

  bool isGettingCaseReports = false;
  bool isGettingPropagationZones = false;

  bool isGettingCaseReport = false;
  bool isGettingPropagationZone = false;

  Future<List<CaseReportSummarizedModel>?> getCaseReportsSummarized() async {
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
        return null;
      }
    } on DioError catch (_) {
      isGettingCaseReports = false;
      notifyListeners();
      debugPrint('Error: ${_.message}');
      return null;
    } catch (e) {
      isGettingCaseReports = false;
      notifyListeners();
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<List<PropagationZoneSummarizedModel>?>
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
        return null;
      }
    } on DioError catch (_) {
      isGettingPropagationZones = false;
      notifyListeners();
      debugPrint('Error: ${_.message}');
      return null;
    } catch (e) {
      isGettingPropagationZones = false;
      notifyListeners();
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<CaseReportModel?> getCaseReport(String idCaseReport) async {
    try {
      isGettingCaseReport = true;
      notifyListeners();
      final response = await _dio.get('/case-report/$idCaseReport');
      if (response.statusCode == 200) {
        isGettingCaseReport = false;
        notifyListeners();
        return CaseReportModel.fromJson(response.data['data']);
      } else {
        isGettingCaseReport = false;
        notifyListeners();
        return null;
      }
    } on DioError catch (_) {
      isGettingCaseReport = false;
      notifyListeners();
      return null;
    } catch (e) {
      isGettingCaseReport = false;
      notifyListeners();
      return null;
    }
  }

  Future<PropagationZoneModel?> getPropagationZone(
      String idPropagationZone) async {
    try {
      isGettingPropagationZone = true;
      notifyListeners();
      final response = await _dio.get('/propagation-zone/$idPropagationZone');
      if (response.statusCode == 200) {
        isGettingPropagationZone = false;
        notifyListeners();
        return PropagationZoneModel.fromJson(response.data['data']);
      } else {
        isGettingPropagationZone = false;
        notifyListeners();
        return null;
      }
    } on DioError catch (_) {
      isGettingPropagationZone = false;
      notifyListeners();
      return null;
    } catch (e) {
      isGettingPropagationZone = false;
      notifyListeners();
      return null;
    }
  }
}
