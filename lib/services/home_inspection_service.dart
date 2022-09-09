import 'dart:convert';
import 'dart:io';

import 'package:denv_mobile/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

class HomeInspectionService extends ChangeNotifier {
  final String _cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dq5dl67s2';
  final String _uploadPreset = 'sgtxqlcv';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://18.207.168.16',
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
      connectTimeout: 3 * 1000,
      receiveTimeout: 3 * 1000,
    ),
  );

  bool isSavingNewHomeInspection = false;

  Future<HomeInspectionModel?> createNewHomeInspection(
      HomeInspectionModel homeInspection) async {
    try {
      isSavingNewHomeInspection = true;
      notifyListeners();

      final jsonHomeInspection = homeInspection.toJson();
      final response = await _dio.post(
        '/home-inspection',
        data: jsonHomeInspection,
        onSendProgress: (int sent, int total) {
          debugPrint('$sent $total');
        },
      );
      if (response.statusCode == 201) {
        isSavingNewHomeInspection = false;
        notifyListeners();
        return HomeInspectionModel.fromJson(response.data['data']);
      } else {
        isSavingNewHomeInspection = false;
        notifyListeners();
        return null;
      }
    } on DioError catch (_) {
      isSavingNewHomeInspection = false;
      notifyListeners();
      return null;
    } catch (e) {
      isSavingNewHomeInspection = false;
      notifyListeners();
      return null;
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      final url = Uri.parse(
          '$_cloudinaryUrl/image/upload?upload_preset=$_uploadPreset');
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
