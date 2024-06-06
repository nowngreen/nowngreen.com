import 'package:nowlive/model/avatarmodel.dart';
import 'package:nowlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class AvatarProvider extends ChangeNotifier {
  AvatarModel avatarModel = AvatarModel();

  bool loading = false;

  setLoading(isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  Future<void> getAvatar() async {
    loading = true;
    avatarModel = await ApiService().getAvatar();
    debugPrint("getAvatar status :==> ${avatarModel.status}");
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    avatarModel = AvatarModel();
  }
}
