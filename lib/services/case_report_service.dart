import 'dart:convert';
import 'dart:io';

import 'package:denv_mobile/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

class CaseReportService extends ChangeNotifier {
  final String _cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dq5dl67s2';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://20.206.152.104',
      contentType: 'application/json',
    ),
  );

  Future<CaseReportModel?> createNewCaseReport(
      CaseReportModel caseReport) async {
    try {
      final jsonCaseReport = caseReport.toJson();
      final response = await _dio.post(
        '/case-report',
        data: jsonCaseReport,
        onSendProgress: (int sent, int total) {
          debugPrint('$sent $total');
        },
      );
      if (response.statusCode == 201) {
        return CaseReportModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      final url =
          Uri.parse('$_cloudinaryUrl/image/upload?upload_preset=sgtxqlcv');
      final mimeType = mime(image.path)!.split('/');

      final imageUploadRequest = http.MultipartRequest('POST', url);
      final file = await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType(
          mimeType[0],
          mimeType[1],
        ),
      );
      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();

      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      } else {
        return json.decode(response.body)['secure_url'];
      }
    } catch (e) {
      return null;
    }
  }
}
