import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:deteccion_zonas_dengue/sources/models/mosquito_photo_model.dart';

class MosquitoPhotoProvider {
  final String _url = 'https://deteccion-zonas-dengue-default-rtdb.firebaseio.com';

  Future<bool> createMosquitoPhoto(MosquitoPhotoModel mosquitoPhoto) async {
    final url = '$_url/fotos-mosquitos.json';
    final response = await http.post(Uri.parse(url), body: mosquitoPhotoToJson(mosquitoPhoto));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MosquitoPhotoModel>> getAllMosquitoPhotos() async {
    final url = '$_url/fotos-mosquitos.json';
    final response = await http.get(Uri.parse(url));

    final Map<String, dynamic>? decodedData = json.decode(response.body);
    final List<MosquitoPhotoModel> photos = [];

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, photo) {
      final photoTemp = MosquitoPhotoModel.fromJson(photo);
      photoTemp.id = id;
      photos.add(photoTemp);
    });

    return photos;
  }

  Future<String> uploadPhoto(File image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dq5dl67s2/image/upload?upload_preset=faz5r1mr');
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
