import 'package:denv_mobile/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MapService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://18.207.168.16',
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
      connectTimeout: 3 * 1000,
      receiveTimeout: 3 * 1000,
    ),
  );

  bool isGettingHomeInspections = false;
  bool isGettingVectorRecords = false;

  bool isGettingHomeInspection = false;
  bool isGettingVectorRecord = false;

  Future<List<HomeInspectionSummarizedModel>?>
      getHomeInspectionsSummarized() async {
    try {
      isGettingHomeInspections = true;
      notifyListeners();
      final response = await _dio.get('/home-inspections-summarized');
      if (response.statusCode == 200) {
        isGettingHomeInspections = false;
        notifyListeners();
        if (response.data['data'] == null) {
          return List<HomeInspectionSummarizedModel>.empty();
        } else {
          return (response.data['data'] as List<dynamic>)
              .map((e) => HomeInspectionSummarizedModel.fromJson(e))
              .toList();
        }
      } else {
        isGettingHomeInspections = false;
        notifyListeners();
        return null;
      }
    } on DioError catch (_) {
      isGettingHomeInspections = false;
      notifyListeners();
      debugPrint('Error: ${_.message}');
      return null;
    } catch (e) {
      isGettingHomeInspections = false;
      notifyListeners();
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<List<VectorRecordSummarizedModel>?>
      getVectorRecordsSummarized() async {
    try {
      isGettingVectorRecords = true;
      notifyListeners();
      final response = await _dio.get('/vector-records-summarized');
      if (response.statusCode == 200) {
        isGettingVectorRecords = false;
        notifyListeners();
        if (response.data['data'] == null) {
          return List<VectorRecordSummarizedModel>.empty();
        } else {
          return (response.data['data'] as List<dynamic>)
              .map((e) => VectorRecordSummarizedModel.fromJson(e))
              .toList();
        }
      } else {
        isGettingVectorRecords = false;
        notifyListeners();
        return null;
      }
    } on DioError catch (_) {
      isGettingVectorRecords = false;
      notifyListeners();
      debugPrint('Error: ${_.message}');
      return null;
    } catch (e) {
      isGettingVectorRecords = false;
      notifyListeners();
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<HomeInspectionModel?> getHomeInspection(
      String idHomeInspection) async {
    try {
      isGettingHomeInspection = true;
      notifyListeners();
      final response = await _dio.get('/home-inspection/$idHomeInspection');
      if (response.statusCode == 200) {
        isGettingHomeInspection = false;
        notifyListeners();
        return HomeInspectionModel.fromJson(response.data['data']);
      } else {
        isGettingHomeInspection = false;
        notifyListeners();
        return null;
      }
    } on DioError catch (_) {
      isGettingHomeInspection = false;
      notifyListeners();
      return null;
    } catch (e) {
      isGettingHomeInspection = false;
      notifyListeners();
      return null;
    }
  }

  Future<VectorRecordModel?> getVectorRecord(String idVectorRecord) async {
    try {
      isGettingVectorRecord = true;
      notifyListeners();
      final response = await _dio.get('/vector-record/$idVectorRecord');
      if (response.statusCode == 200) {
        isGettingVectorRecord = false;
        notifyListeners();
        return VectorRecordModel.fromJson(response.data['data']);
      } else {
        isGettingVectorRecord = false;
        notifyListeners();
        return null;
      }
    } on DioError catch (_) {
      isGettingVectorRecord = false;
      notifyListeners();
      return null;
    } catch (e) {
      isGettingVectorRecord = false;
      notifyListeners();
      return null;
    }
  }
}
