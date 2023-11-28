import 'package:flutter/material.dart';

class SpotInformationModel extends ChangeNotifier {

  Map spotInfo = {};
  List reviewsList = [];
  String imageUrl = "";
  bool isChecked = false;
  bool isNear = false;
  void updateSpotInfo(data) {
    spotInfo = data;
    notifyListeners();
  }
  void updateImageUrl(data) {
    imageUrl = data;
    notifyListeners();
  }
  void updateReviewsList(data) {
    reviewsList = data;
    notifyListeners();
  }
  void updateIsChecked(data) {
    isChecked = data;
    notifyListeners();
  }
  void updateIsNear(data) {
    isNear = data;
    notifyListeners();
  }


}