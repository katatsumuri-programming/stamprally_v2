import 'package:flutter/material.dart';

class UnusedRewardModel extends ChangeNotifier {

  Map unusedRewardInfo = {};
  String imageUrl = "";

  void updateUnusedRewardInfo(data) {
    unusedRewardInfo = data;
    notifyListeners();
  }
  void updateImageUrl(data) {
    imageUrl = data;
    notifyListeners();
  }

}