

import 'package:nowlive/model/rentmodel.dart';
import 'package:nowlive/utils/constant.dart';
import 'package:nowlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class PurchaselistProvider extends ChangeNotifier {
  RentModel rentModel = RentModel();
  bool loading = false;

  Future<void> getUserRentVideoList() async {
    debugPrint("getUserRentVideoList userID :==> ${Constant.userID}");
    loading = true;
    rentModel = await ApiService().userRentVideoList();
    debugPrint("user_rent_video_list status :==> ${rentModel.status}");
    debugPrint("user_rent_video_list message :==> ${rentModel.message}");
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    rentModel = RentModel();
  }
}
