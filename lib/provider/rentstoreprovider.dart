import 'package:nowlive/model/rentmodel.dart';
import 'package:nowlive/utils/constant.dart';
import 'package:nowlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class RentStoreProvider extends ChangeNotifier {
  RentModel rentModel = RentModel();

  bool loading = false;

  setLoading(isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  Future<void> getRentVideoList() async {
    debugPrint("getRentVideoList userID :==> ${Constant.userID}");
    loading = true;
    rentModel = await ApiService().rentVideoList();
    debugPrint("rent_video_list status :==> ${rentModel.status}");
    debugPrint("rent_video_list message :==> ${rentModel.message}");
    loading = false;
    notifyListeners();
  }

  clearRentStoreProvider() {
    debugPrint("<================ clearRentStoreProvider ================>");
    rentModel = RentModel();
  }
}
