import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

class HomeInspectionProvider extends ChangeNotifier {
  String? _comment;
  File? _image;
  DateTime? _datetime;
  Position? _position;
  GeocodingResult? _address;

  String? get comment => _comment;
  File? get image => _image;
  DateTime? get datetime => _datetime;
  Position? get position => _position;
  GeocodingResult? get address => _address;

  void setComment(String? comment) {
    _comment = comment;
    notifyListeners();
  }

  void setImage(File? image) {
    _image = image;
    notifyListeners();
  }

  void setDatetime(DateTime? datetime) {
    _datetime = datetime;
    notifyListeners();
  }

  void setPosition(Position? position) {
    _position = position;
    notifyListeners();
  }

  void setAddress(GeocodingResult? address) {
    _address = address;
    notifyListeners();
  }
}
