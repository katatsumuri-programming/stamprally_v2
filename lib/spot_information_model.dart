import 'package:flutter/material.dart';

class SpotInformationModel extends ChangeNotifier {

  List spotsList = [];
  List reviewsList = [];
  void updateSpotsList(data) {
    spotsList = data;
    notifyListeners();
  }
  void updateReviewsList(data) {
    reviewsList = data;
    notifyListeners();
  }


}