import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Servicios de localización deshabilitados');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Permisos de localización denegados');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Permisos de localización denegados permanentemente');
  }

  return await Geolocator.getCurrentPosition();
}

Future<Address> getDirection({required double latitude, required double longitude}) async {
  GeoCode geoCode = GeoCode();
  return await geoCode.reverseGeocoding(latitude: latitude, longitude: longitude);
}
