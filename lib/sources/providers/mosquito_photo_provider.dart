import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_photo_model.dart';

class MosquitoPhotoProvider {
  // URL Backend
  final String _url = 'http://40.124.84.39';

  Future<bool> createMosquitoPhoto(MosquitoPhotoModel mosquitoPhoto) async {
    final url = '$_url/photo';
    final response = await http.post(Uri.parse(url), body: mosquitoPhotoToJson(mosquitoPhoto));
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return false;

    if (decodedData["message"] == "success") {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MosquitoPhotoModel>> getAllMosquitoPhotos() async {
    final url = '$_url/photos';
    final response = await http.get(Uri.parse(url));

    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return [];

    if (decodedData['message'] != 'success') return [];

    final mosquitoPhotoResponse = MosquitoPhotoResponse.fromJson(decodedData);

    return mosquitoPhotoResponse.data.data;
  }

  Future<String> uploadPhoto(File image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dq5dl67s2/image/upload?upload_preset=sgtxqlcv');
    final mimeType = mime(image.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final response = await http.Response.fromStream(streamResponse);
    if (response.statusCode != 200 && response.statusCode != 201) {
      return '-';
    }
    final responseData = json.decode(response.body);
    return responseData['secure_url'];
  }
}
