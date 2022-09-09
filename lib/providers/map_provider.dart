import 'package:denv_mobile/models/models.dart';
import 'package:flutter/material.dart';

class MapProvider extends ChangeNotifier {
  List<HomeInspectionSummarizedModel> _homeInspectionsSummarized = [];
  List<VectorRecordSummarizedModel> _vectorRecordsSummarized = [];

  List<HomeInspectionSummarizedModel> get homeInspectionsSummarized =>
      _homeInspectionsSummarized;
  List<VectorRecordSummarizedModel> get vectorRecordsSummarized =>
      _vectorRecordsSummarized;

  void setHomeInspectionsSummarized(
      List<HomeInspectionSummarizedModel> homeInspectionsSummarized) {
    _homeInspectionsSummarized = homeInspectionsSummarized;
    notifyListeners();
  }

  void setVectorRecordsSummarized(
      List<VectorRecordSummarizedModel> vectorRecordsSummarized) {
    _vectorRecordsSummarized = vectorRecordsSummarized;
    notifyListeners();
  }
}
