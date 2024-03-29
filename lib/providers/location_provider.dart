import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;
  GeocodingResult? currentAddress;

  bool locationEnabled = true;
  bool isGettingAddress = false;

  bool isUpdatingPosition = false;
  bool isUpdatingAddress = false;

  LocationProvider() {
    getAddress();
  }

  Future<bool> getLocation() async {
    LocationPermission permission;
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      locationEnabled = false;
      notifyListeners();
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationEnabled = false;
        notifyListeners();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      locationEnabled = false;
      notifyListeners();
      return false;
    }
    currentPosition = await Geolocator.getCurrentPosition();

    return true;
  }

  Future<bool> getAddress() async {
    isGettingAddress = true;
    notifyListeners();

    bool result = await getLocation();
    if (!result) {
      isGettingAddress = false;
      notifyListeners();
      return false;
    }

    GoogleGeocoding googleGeocoding =
        GoogleGeocoding('AIzaSyBy-ZP5BSbdESqotdxt9G5gMxZILYRJ0Ng');
    LatLon latLon =
        LatLon(currentPosition!.latitude, currentPosition!.longitude);
    GeocodingResponse? geocodingResponse =
        await googleGeocoding.geocoding.getReverse(latLon, language: 'es');
    currentAddress = geocodingResponse?.results?.first;

    isGettingAddress = false;
    notifyListeners();

    return true;
  }

  Future<bool> getCurrentPosition() async {
    isUpdatingPosition = true;
    notifyListeners();

    currentPosition = await Geolocator.getCurrentPosition();

    isUpdatingPosition = false;
    notifyListeners();

    return true;
  }

  Future<bool> getCurrentAddress() async {
    isUpdatingAddress = true;
    notifyListeners();

    GoogleGeocoding googleGeocoding =
        GoogleGeocoding('AIzaSyBy-ZP5BSbdESqotdxt9G5gMxZILYRJ0Ng');
    Position position = await Geolocator.getCurrentPosition();
    LatLon latLon = LatLon(position.latitude, position.longitude);
    GeocodingResponse? geocodingResponse =
        await googleGeocoding.geocoding.getReverse(
      latLon,
      language: 'es',
    );
    currentAddress = geocodingResponse?.results?.first;

    isUpdatingAddress = false;
    notifyListeners();

    return true;
  }
}
