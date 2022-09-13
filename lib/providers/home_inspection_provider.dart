import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

class HomeInspectionProvider extends ChangeNotifier {
  String? _block;
  int? _lot;

  int? _numberInhabitants;

  int? _inspectedHome;
  int? _reluctantDwelling;
  int? _closedHouse;
  int? _uninhabitedHouse;
  int? _housingSpotlights;
  int? _treatedHousing;

  int? _elevatedTankI;
  int? _elevatedTankP;
  int? _elevatedTankT;

  int? _lowTankI;
  int? _lowTankP;
  int? _lowTankT;

  int? _cylinderBarrelI;
  int? _cylinderBarrelP;
  int? _cylinderBarrelT;

  int? _bucketTubI;
  int? _bucketTubP;
  int? _bucketTubT;

  int? _tireI;
  int? _tireP;
  int? _tireT;

  int? _flowerI;
  int? _flowerP;
  int? _flowerT;

  int? _uselessI;
  int? _uselessP;
  int? _uselessT;

  int? _othersI;
  int? _othersP;
  int? _othersT;

  int? _inspectedContainers;
  int? _containersSpotlights;
  int? _treatedContainers;
  int? _destroyedContainers;

  int? _larvae;
  int? _pupae;
  int? _adult;

  double? _larvicide;

  String? _comment;
  File? _image;
  DateTime? _datetime;
  Position? _position;
  GeocodingResult? _address;

  String? get block => _block;
  int? get lot => _lot;

  int? get numberInhabitants => _numberInhabitants;

  int? get inspectedHome => _inspectedHome;
  int? get reluctantDwelling => _reluctantDwelling;
  int? get closedHouse => _closedHouse;
  int? get uninhabitedHouse => _uninhabitedHouse;
  int? get housingSpotlights => _housingSpotlights;
  int? get treatedHousing => _treatedHousing;

  int? get elevatedTankI => _elevatedTankI;
  int? get elevatedTankP => _elevatedTankP;
  int? get elevatedTankT => _elevatedTankT;

  int? get lowTankI => _lowTankI;
  int? get lowTankP => _lowTankP;
  int? get lowTankT => _lowTankT;

  int? get cylinderBarrelI => _cylinderBarrelI;
  int? get cylinderBarrelP => _cylinderBarrelP;
  int? get cylinderBarrelT => _cylinderBarrelT;

  int? get bucketTubI => _bucketTubI;
  int? get bucketTubP => _bucketTubP;
  int? get bucketTubT => _bucketTubT;

  int? get tireI => _tireI;
  int? get tireP => _tireP;
  int? get tireT => _tireT;

  int? get flowerI => _flowerI;
  int? get flowerP => _flowerP;
  int? get flowerT => _flowerT;

  int? get uselessI => _uselessI;
  int? get uselessP => _uselessP;
  int? get uselessT => _uselessT;

  int? get othersI => _othersI;
  int? get othersP => _othersP;
  int? get othersT => _othersT;

  int? get inspectedContainers => _inspectedContainers;
  int? get containersSpotlights => _containersSpotlights;
  int? get treatedContainers => _treatedContainers;
  int? get destroyedContainers => _destroyedContainers;

  int? get larvae => _larvae;
  int? get pupae => _pupae;
  int? get adult => _adult;

  double? get larvicide => _larvicide;

  String? get comment => _comment;
  File? get image => _image;
  DateTime? get datetime => _datetime;
  Position? get position => _position;
  GeocodingResult? get address => _address;

  void setBlock(String? value) {
    _block = value;
    notifyListeners();
  }

  void setLot(int? value) {
    _lot = value;
    notifyListeners();
  }

  void setNumberInhabitants(int? value) {
    _numberInhabitants = value;
    notifyListeners();
  }

  void setInspectedHome(int? value) {
    _inspectedHome = value;
    notifyListeners();
  }

  void setReluctantDwelling(int? value) {
    _reluctantDwelling = value;
    notifyListeners();
  }

  void setClosedHouse(int? value) {
    _closedHouse = value;
    notifyListeners();
  }

  void setUninhabitedHouse(int? value) {
    _uninhabitedHouse = value;
    notifyListeners();
  }

  void setHousingSpotlights(int? value) {
    _housingSpotlights = value;
    notifyListeners();
  }

  void setTreatedHousing(int? value) {
    _treatedHousing = value;
    notifyListeners();
  }

  void setElevatedTankI(int? value) {
    _elevatedTankI = value;
    notifyListeners();
  }

  void setElevatedTankP(int? value) {
    _elevatedTankP = value;
    notifyListeners();
  }

  void setElevatedTankT(int? value) {
    _elevatedTankT = value;
    notifyListeners();
  }

  void setLowTankI(int? value) {
    _lowTankI = value;
    notifyListeners();
  }

  void setLowTankP(int? value) {
    _lowTankP = value;
    notifyListeners();
  }

  void setLowTankT(int? value) {
    _lowTankT = value;
    notifyListeners();
  }

  void setCylinderBarrelI(int? value) {
    _cylinderBarrelI = value;
    notifyListeners();
  }

  void setCylinderBarrelP(int? value) {
    _cylinderBarrelP = value;
    notifyListeners();
  }

  void setCylinderBarrelT(int? value) {
    _cylinderBarrelT = value;
    notifyListeners();
  }

  void setBucketTubI(int? value) {
    _bucketTubI = value;
    notifyListeners();
  }

  void setBucketTubP(int? value) {
    _bucketTubP = value;
    notifyListeners();
  }

  void setBucketTubT(int? value) {
    _bucketTubT = value;
    notifyListeners();
  }

  void setTireI(int? value) {
    _tireI = value;
    notifyListeners();
  }

  void setTireP(int? value) {
    _tireP = value;
    notifyListeners();
  }

  void setTireT(int? value) {
    _tireT = value;
    notifyListeners();
  }

  void setFlowerI(int? value) {
    _flowerI = value;
    notifyListeners();
  }

  void setFlowerP(int? value) {
    _flowerP = value;
    notifyListeners();
  }

  void setFlowerT(int? value) {
    _flowerT = value;
    notifyListeners();
  }

  void setUselessI(int? value) {
    _uselessI = value;
    notifyListeners();
  }

  void setUselessP(int? value) {
    _uselessP = value;
    notifyListeners();
  }

  void setUselessT(int? value) {
    _uselessT = value;
    notifyListeners();
  }

  void setOthersI(int? value) {
    _othersI = value;
    notifyListeners();
  }

  void setOthersP(int? value) {
    _othersP = value;
    notifyListeners();
  }

  void setOthersT(int? value) {
    _othersT = value;
    notifyListeners();
  }

  void setInspectedContainers(int? value) {
    _inspectedContainers = value;
    notifyListeners();
  }

  void setContainersSpotlights(int? value) {
    _containersSpotlights = value;
    notifyListeners();
  }

  void setTreatedContainers(int? value) {
    _treatedContainers = value;
    notifyListeners();
  }

  void setDestroyedContainers(int? value) {
    _destroyedContainers = value;
    notifyListeners();
  }

  void setLarvae(int? value) {
    _larvae = value;
    notifyListeners();
  }

  void setPupae(int? value) {
    _pupae = value;
    notifyListeners();
  }

  void setAdult(int? value) {
    _adult = value;
    notifyListeners();
  }

  void setLarvicide(double? value) {
    _larvicide = value;
    notifyListeners();
  }

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
