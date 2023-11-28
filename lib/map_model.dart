import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapModel extends ChangeNotifier {

  List<CircleMarker> circleMarkers = [];
  List<double> myLocation = [0,0];
  bool locationTracking = true;
  bool isMapDisplayed = false;
  // Map<int, MapController> mapControllers = {mapConst.MAP_PAGE:MapController(), mapConst.SPOT_INFORMATION_MAP:MapController(), mapConst.STAMPRALLY_INFORMATION_MAP:MapController()};
  // Map<int, double> zoomLevels = {mapConst.MAP_PAGE:16.0, mapConst.MAP_PAGE:16.0};
  MapController mapController = MapController();
  double zoomLevel = 16.0;

  void updateMyLocation(latitude, longitude) {
    myLocation = [latitude, longitude];
    notifyListeners();
  }
  void updateCircleMarkers(latitude, longitude) {

    CircleMarker circleMarker = CircleMarker(
      color: Colors.blue,
      radius: 9,
      borderColor: Colors.white,
      borderStrokeWidth: 3,
      point: LatLng(latitude, longitude),
    );
    circleMarkers.clear();
    circleMarkers.add(circleMarker);
    notifyListeners();
  }
  void updateLocationTracking(bool data) {
    locationTracking = data;
    notifyListeners();
  }
  void updateZoomLevel(double data) {
    zoomLevel = data;
    notifyListeners();
  }
  void updateIsMapDisplayed(bool data) {
    isMapDisplayed = data;
  }
  void initMapController() {
    mapController = MapController();
    notifyListeners();
  }
}

class mapConst {
  static const int MAP_PAGE = 0;
  static const int SPOT_INFORMATION_MAP = 1;
  static const int STAMPRALLY_INFORMATION_MAP = 2;
}