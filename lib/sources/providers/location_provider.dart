import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

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

Future<String> getCity({required double latitude, required double longitude}) async {
  GoogleGeocoding googleGeocoding = GoogleGeocoding('AIzaSyBy-ZP5BSbdESqotdxt9G5gMxZILYRJ0Ng');
  LatLon latLon = LatLon(latitude, longitude);
  GeocodingResponse? response = await googleGeocoding.geocoding.getReverse(latLon, language: 'es');
  if (response != null) {
    if (response.results != null) {
      if (response.results!.isNotEmpty) {
        if (response.results![0].addressComponents != null) {
          if (response.results![0].addressComponents!.isNotEmpty) {
            for (var element in response.results![0].addressComponents!) {
              if (element.types![0] == 'administrative_area_level_2') {
                return element.longName!;
              }
            }
          }
        }
      }
    }
  }
  return '-';
}

Future<String> getAddress({required double latitude, required double longitude}) async {
  GoogleGeocoding googleGeocoding = GoogleGeocoding('AIzaSyBy-ZP5BSbdESqotdxt9G5gMxZILYRJ0Ng');
  LatLon latLon = LatLon(latitude, longitude);
  GeocodingResponse? response = await googleGeocoding.geocoding.getReverse(latLon, language: 'es');
  if (response != null) {
    if (response.results != null) {
      if (response.results!.isNotEmpty) {
        if (response.results![0].formattedAddress != null) {
          return response.results![0].formattedAddress!;
        }
      }
    }
  }
  return '-';
}
