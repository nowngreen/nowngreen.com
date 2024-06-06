

import 'package:nowlive/model/searchmodel.dart';
import 'package:nowlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  SearchModel searchModel = SearchModel();

  bool loading = false, isVideoClick = true, isShowClick = false;

  Future<void> getSearchVideo(searchText) async {
    debugPrint("getSearchVideos searchText :==> $searchText");
    loading = true;
    searchModel = await ApiService().searchVideo(searchText);
    debugPrint("search_video status :==> ${searchModel.status}");
    debugPrint("search_video message :==> ${searchModel.message}");
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    debugPrint("setDataVisibility isLoading :==> $isLoading");
    loading = isLoading;
    notifyListeners();
  }

  void setDataVisibility(bool isVideoVisible, bool isShowVisible) {
    debugPrint("setDataVisibility isVideoVisible :==> $isVideoVisible");
    debugPrint("setDataVisibility isShowVisible :==> $isShowVisible");
    isVideoClick = isVideoVisible;
    isShowClick = isShowVisible;
    notifyListeners();
  }

  notifyProvider() {
    notifyListeners();
  }

  clearProvider() {
    debugPrint("============ clearSearchProvider ============");
    searchModel = SearchModel();
    isVideoClick = true;
    isShowClick = false;
  }
}
