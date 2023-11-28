import 'package:flutter/material.dart';

class RewardsListModel extends ChangeNotifier {
  List rewardsListAvailable = [];
  List rewardsListUnused = [];
  List rewardsList = [];
  List imageUrlList = [];
  List imageAvailableRewardsUrlList = [];
  List imageUnusedRewardsUrlList = [];
  int pageNumber = 0;


  void updateRewardsListAvailable(data) {
    rewardsListAvailable = data;
    notifyListeners();
  }
  void updateRewardsListUnused(data) {
    rewardsListUnused = data;
    notifyListeners();
  }
  void updateRewardList(data) {
    rewardsList = data;
    notifyListeners();
  }
  void updateImageUrlList(data){
    imageUrlList = data;
    notifyListeners();
  }
  void updateImageAvailableRewardsUrlList(data) {
    imageAvailableRewardsUrlList = data;
    notifyListeners();
  }
  void updateImageUnusedRewardsUrlList(data) {
    imageUnusedRewardsUrlList = data;
    notifyListeners();
  }

  void changedPage (data) {
    pageNumber = data;
    switch (data) {
      case 0:
        rewardsList = rewardsListUnused;
        imageUrlList = imageUnusedRewardsUrlList;
        break;
      case 1:
        rewardsList = rewardsListAvailable;
        imageUrlList = imageAvailableRewardsUrlList;
        break;
    }
    notifyListeners();
  }
}