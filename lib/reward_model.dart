import 'package:flutter/material.dart';

class RewardModel extends ChangeNotifier {

  Map rewardInfo = {};
  String imageUrl = "";
  String rewardStatus = '';
  bool isObtainable = false;

  void updateRewardInfo(data) {
    rewardInfo = data;
    notifyListeners();
  }
  void updateImageUrl(data) {
    imageUrl = data;
    notifyListeners();
  }
  void updateRewardStatus(data) {
    rewardStatus = data;
    notifyListeners();
  }
  void updateIsObtainable(data) {
    isObtainable = data;
    notifyListeners();
  }

}