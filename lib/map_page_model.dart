import 'package:flutter/material.dart';

class MapPageModel extends ChangeNotifier {

  List spotsList = [];
  void updateSpotsList(data) {
    spotsList = data;
    notifyListeners();
  }

}