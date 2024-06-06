import 'package:nowlive/model/profilemodel.dart';
import 'package:nowlive/model/successmodel.dart';
import 'package:nowlive/utils/constant.dart';
import 'package:nowlive/utils/utils.dart';
import 'package:nowlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel profileModel = ProfileModel();
  SuccessModel successNameModel = SuccessModel();
  SuccessModel uploadImgModel = SuccessModel();

  bool loading = false;

  Future<void> getProfile(BuildContext context) async {
    debugPrint("getProfile userID :==> ${Constant.userID}");

    loading = true;
    profileModel = await ApiService().profile();
    debugPrint("get_profile status :==> ${profileModel.status}");
    debugPrint("get_profile message :==> ${profileModel.message}");
    if (profileModel.status == 200 && profileModel.result != null) {
      if ((profileModel.result?.length ?? 0) > 0) {
        Utils.updatePremium(profileModel.result?[0].isBuy.toString() ?? "0");
        if (context.mounted) {
          debugPrint("========= get_profile loadAds =========");
          Utils.loadAds(context);
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  Future<void> getUpdateProfile(name) async {
    debugPrint("getUpdateProfile userID :==> ${Constant.userID}");
    debugPrint("getUpdateProfile name :==> $name");

    loading = true;
    successNameModel = await ApiService().updateProfile(name);
    debugPrint("update_profile status :==> ${successNameModel.status}");
    debugPrint("update_profile message :==> ${successNameModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> getImageUpload(profileImg) async {
    debugPrint("getImageUpload userID :==> ${Constant.userID}");
    debugPrint("getImageUpload profileImg :==> ${profileImg.toString()}");
    loading = true;
    uploadImgModel = await ApiService().imageUpload(profileImg);
    debugPrint("image_upload status :==> ${uploadImgModel.status}");
    debugPrint("image_upload message :==> ${uploadImgModel.message}");
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    profileModel = ProfileModel();
    successNameModel = SuccessModel();
    uploadImgModel = SuccessModel();
    loading = false;
  }
}
