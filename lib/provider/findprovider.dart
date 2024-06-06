import 'package:nowlive/model/genresmodel.dart';
import 'package:nowlive/model/langaugemodel.dart';
import 'package:nowlive/model/sectiontypemodel.dart';
import 'package:nowlive/model/successmodel.dart';
import 'package:nowlive/utils/sharedpre.dart';
import 'package:nowlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class FindProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();
  SectionTypeModel sectionTypeModel = SectionTypeModel();
  LangaugeModel langaugeModel = LangaugeModel();
  GenresModel genresModel = GenresModel();

  bool loading = false, isGenSeeMore = true, isLangSeeMore = true;
  int setLanguageSize = 5, setGenresSize = 5;

  SharedPre sharePref = SharedPre();

  setLoading(isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  Future<void> getSectionType() async {
    loading = true;
    sectionTypeModel = await ApiService().sectionType();
    debugPrint("get_type status :==> ${sectionTypeModel.status}");
    debugPrint("get_type message :==> ${sectionTypeModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> getGenres() async {
    loading = true;
    genresModel = await ApiService().genres();
    debugPrint("get_category status :==> ${genresModel.status}");
    debugPrint("get_category message :==> ${genresModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> getLanguage() async {
    loading = true;
    langaugeModel = await ApiService().language();
    debugPrint("get_language status :==> ${langaugeModel.status}");
    debugPrint("get_language message :==> ${langaugeModel.message}");
    loading = false;
    notifyListeners();
  }

  void setLanguageListSize(int setNewSize) {
    setLanguageSize = setNewSize;
    notifyListeners();
  }

  void setGenresListSize(int setNewSize) {
    setGenresSize = setNewSize;
    notifyListeners();
  }

  void setLangSeeMore(bool isVisible) {
    isLangSeeMore = isVisible;
    notifyListeners();
  }

  void setGenSeeMore(bool isVisible) {
    isGenSeeMore = isVisible;
    notifyListeners();
  }

  clearProvider() {
    debugPrint("============ clearProvider ============");
    successModel = SuccessModel();
    sectionTypeModel = SectionTypeModel();
    langaugeModel = LangaugeModel();
    genresModel = GenresModel();

    isGenSeeMore = true;
    isLangSeeMore = true;
    setLanguageSize = 5;
    setGenresSize = 5;
  }
}
