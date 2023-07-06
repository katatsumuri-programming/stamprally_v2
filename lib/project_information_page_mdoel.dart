import 'package:flutter/material.dart';

class ProjectInformationPageModel extends ChangeNotifier {
  Map<String, dynamic> stamprallyInfo = {};
  String imageUrl = "";
  List rewardsList = [];
  void updateStamprallyInfo(data) {
    stamprallyInfo = data;
    notifyListeners();
  }
  void updateRewardList(data) {
    rewardsList = data;
    notifyListeners();
  }
  void updateImageUrl(data) {
    imageUrl = data;
    notifyListeners();
  }
}