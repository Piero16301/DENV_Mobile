import 'package:denv_mobile/models/models.dart';
import 'package:flutter/material.dart';

class MapProvider extends ChangeNotifier {
  List<CaseReportSummarizedModel> _caseReportsSummarized = [];
  List<PropagationZoneSummarizedModel> _propagationZonesSummarized = [];

  List<CaseReportSummarizedModel> get caseReportsSummarized =>
      _caseReportsSummarized;
  List<PropagationZoneSummarizedModel> get propagationZonesSummarized =>
      _propagationZonesSummarized;

  void setCaseReportsSummarized(
      List<CaseReportSummarizedModel> caseReportsSummarized) {
    _caseReportsSummarized = caseReportsSummarized;
    notifyListeners();
  }

  void setPropagationZonesSummarized(
      List<PropagationZoneSummarizedModel> propagationZonesSummarized) {
    _propagationZonesSummarized = propagationZonesSummarized;
    notifyListeners();
  }
}
