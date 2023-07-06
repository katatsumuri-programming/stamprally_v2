import 'package:flutter/material.dart';

class RewardsModel extends ChangeNotifier {

  List rewardsList = [];
  void updateRewardList(data) {
    rewardsList = data;
    notifyListeners();
  }

}