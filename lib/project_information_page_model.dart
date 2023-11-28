import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class ProjectInformationPageModel extends ChangeNotifier {
  Map<String, dynamic> stamprallyInfo = {};
  String imageUrl = "";
  List spotsList = [];
  List imageUrlList = [];
  LatLngBounds bounds = LatLngBounds(LatLng(0,0), LatLng(0,0));

  void updateStamprallyInfo(data) {
    stamprallyInfo = data;
    notifyListeners();
  }
  void updateSpotList(data) {
    spotsList = data;
    notifyListeners();
  }
  void updateImageUrl(data) {
    imageUrl = data;
    notifyListeners();
  }
  void updateImageUrlList(data) {
    imageUrlList = data;
    notifyListeners();
  }
  void updateBounds(data) {
    bounds = data;
    notifyListeners();
  }
}