import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;
  GeocodingResult? currentAddress;

  bool locationEnabled = true;
  bool isGettingAddress = false;

  LocationProvider() {
    getAddress();
  }

  Future<bool> getLocation() async {
    LocationPermission permission;
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      locationEnabled = false;
      notifyListeners();
      return Future.error('Servicios de localización deshabilitados');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationEnabled = false;
        notifyListeners();
        return Future.error('Permisos de localización denegados');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      locationEnabled = false;
      notifyListeners();
      return Future.error('Permisos de localización denegados permanentemente');
    }
    currentPosition = await Geolocator.getCurrentPosition();

    return true;
  }

  Future<bool> getAddress() async {
    isGettingAddress = true;
    notifyListeners();

    await getLocation();

    GoogleGeocoding googleGeocoding = GoogleGeocoding('AIzaSyBy-ZP5BSbdESqotdxt9G5gMxZILYRJ0Ng');
    LatLon latLon = LatLon(currentPosition!.latitude, currentPosition!.longitude);
    GeocodingResponse? geocodingResponse = await googleGeocoding.geocoding.getReverse(latLon, language: 'es');
    currentAddress = geocodingResponse?.results?.first;

    isGettingAddress = false;
    notifyListeners();

    return true;
  }
}