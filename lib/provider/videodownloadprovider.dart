import 'dart:convert';

import 'dart:io';
import 'package:nowlive/utils/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;

import 'package:nowlive/model/downloadvideomodel.dart';
import 'package:nowlive/model/sectiondetailmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';

class VideoDownloadProvider extends ChangeNotifier {
  List<DownloadVideoModel>? currentTasks;
  DownloadVideoModel? downloadTaskInfo;
  int dProgress = 0;

  // Create storage
  final storage = const FlutterSecureStorage();

  bool loading = false;

  Future<void> prepareDownload(
      Result? sectionDetails, String? localPath, String? mFileName) async {
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) {
      debugPrint('No tasks were retrieved from the database.');
      return;
    }

    currentTasks = [];

    debugPrint('videoExtension ============> ${sectionDetails?.videoExtension}');
    DownloadVideoModel taskInfo = DownloadVideoModel(
      id: sectionDetails?.id,
      taskId: sectionDetails?.id.toString(),
      name: sectionDetails?.name,
      description: sectionDetails?.description,
      videoUrl: sectionDetails?.video320,
      savedDir: localPath,
      savedFile: path.join(localPath ?? '',
          '$mFileName.${sectionDetails?.videoExtension != '' ? (sectionDetails?.videoExtension ?? 'mp4') : 'mp4'}'),
      videoType: sectionDetails?.videoType,
      typeId: sectionDetails?.typeId,
      isPremium: sectionDetails?.isPremium,
      isBuy: sectionDetails?.isBuy,
      isRent: sectionDetails?.isRent,
      rentBuy: sectionDetails?.rentBuy,
      rentPrice: sectionDetails?.rentPrice,
      isDownload: 1,
      videoUploadType: sectionDetails?.videoUploadType,
      trailerUploadType: sectionDetails?.trailerType,
      trailerUrl: sectionDetails?.trailerUrl,
      videoDuration: sectionDetails?.videoDuration,
      releaseYear: sectionDetails?.releaseYear,
      landscapeImg: sectionDetails?.landscape,
      thumbnailImg: sectionDetails?.thumbnail,
    );
    currentTasks?.add(taskInfo);
    debugPrint('currentTasks ============> ${currentTasks?.length}');
    _requestDownload(taskInfo);
  }

  Future<void> _requestDownload(DownloadVideoModel task) async {
    debugPrint('savedFile ============> ${task.savedFile}');
    debugPrint('savedDir ============> ${task.savedDir}');
    debugPrint('link ============> ${task.videoUrl!}');
    task.taskId = await FlutterDownloader.enqueue(
      url: task.videoUrl ?? "",
      headers: {'auth': 'test_for_sql_encoding'},
      fileName: basename(task.savedFile ?? ''),
      savedDir: task.savedDir ?? '',
      saveInPublicStorage: false,
    );
  }

  saveInSecureStorage() async {
    List<DownloadVideoModel>? myVideoList;

    String? listString = await storage.read(
            key: "${Constant.hawkVIDEOList}${Constant.userID}") ??
        '';
    debugPrint("listString ===> $listString");
    if (listString != "") {
      myVideoList = List<DownloadVideoModel>.from(
          jsonDecode(listString)?.map((x) => DownloadVideoModel.fromJson(x)) ??
              []);
    }
    debugPrint("myVideoList ===> ${myVideoList?.length}");

    if ((myVideoList?.length ?? 0) > 0) {
      await checkVideoInSecure(
          myVideoList, currentTasks?[0].id.toString() ?? "");
    }
    if ((myVideoList?.length ?? 0) > 0 || (currentTasks?.length ?? 0) > 0) {
      myVideoList = (myVideoList ?? []) + (currentTasks ?? []);
    }
    debugPrint("myVideoList ===> ${myVideoList?.length}");

    await storage.write(
      key: "${Constant.hawkVIDEOList}${Constant.userID}",
      value: jsonEncode(myVideoList),
    );

    dProgress = 0;
    notifyListeners();
  }

  checkVideoInSecure(
      List<DownloadVideoModel>? myVideoList, String videoID) async {
    debugPrint("checkVideoInSecure UserID ===> ${Constant.userID}");
    debugPrint("checkVideoInSecure videoID ===> $videoID");

    if ((myVideoList?.length ?? 0) == 0) {
      await storage.delete(key: "${Constant.hawkVIDEOList}${Constant.userID}");
      return;
    }
    for (int i = 0; i < (myVideoList?.length ?? 0); i++) {
      debugPrint("Secure itemID ==> ${myVideoList?[i].id}");

      if ((myVideoList?[i].id.toString()) == (videoID)) {
        debugPrint("myVideoList =======================> i = $i");
        myVideoList?.remove(myVideoList[i]);
        if ((myVideoList?.length ?? 0) == 0) {
          await storage.delete(
              key: "${Constant.hawkVIDEOList}${Constant.userID}");
          return;
        }
        await storage.write(
          key: "${Constant.hawkVIDEOList}${Constant.userID}",
          value: jsonEncode(myVideoList),
        );
        return;
      }
    }
  }

  Future<List<DownloadVideoModel>?> getDownloadsByType(String dType) async {
    loading = true;
    List<DownloadVideoModel>? myDownloadsList;
    if (dType == "video") {
      String? listString = await storage.read(
              key: "${Constant.hawkVIDEOList}${Constant.userID}") ??
          '';
      debugPrint("listString ===> ${listString.toString()}");
      if (listString != "") {
        myDownloadsList = List<DownloadVideoModel>.from(jsonDecode(listString)
                ?.map((x) => DownloadVideoModel.fromJson(x)) ??
            []);
      }
      loading = false;
      notifyListeners();
      return myDownloadsList;
    } else if (dType == "show") {
      loading = true;
      List<DownloadVideoModel>? myDownloadsList;
      String? listString = await storage.read(
              key: "${Constant.hawkSHOWList}${Constant.userID}") ??
          '';
      debugPrint("listString ===> ${listString.toString()}");
      if (listString != "") {
        myDownloadsList = List<DownloadVideoModel>.from(jsonDecode(listString)
                ?.map((x) => DownloadVideoModel.fromJson(x)) ??
            []);
      }
      loading = false;
      notifyListeners();
      return myDownloadsList;
    } else {
      loading = false;
      notifyListeners();
      return myDownloadsList;
    }
  }

  Future<void> deleteVideoFromDownload(String videoID) async {
    debugPrint("deleteVideoFromDownload UserID ===> ${Constant.userID}");
    debugPrint("deleteVideoFromDownload videoID ===> $videoID");
    List<DownloadVideoModel>? myVideoList = [];
    String? listString = await storage.read(
            key: '${Constant.hawkVIDEOList}${Constant.userID}') ??
        '';
    debugPrint("listString ===> $listString");
    if (listString != "") {
      myVideoList = List<DownloadVideoModel>.from(
          jsonDecode(listString)?.map((x) => DownloadVideoModel.fromJson(x)) ??
              []);
    }
    debugPrint("myVideoList ===> ${myVideoList.length}");

    if (myVideoList.isEmpty) {
      await storage.delete(key: "${Constant.hawkVIDEOList}${Constant.userID}");
      return;
    }
    for (int i = 0; i < myVideoList.length; i++) {
      debugPrint("Secure itemID ==> ${myVideoList[i].id}");

      if ((myVideoList[i].id.toString()) == (videoID)) {
        debugPrint("myVideoList =======================> i = $i");
        String filePath = myVideoList[i].savedFile ?? "";
        myVideoList.remove(myVideoList[i]);
        File file = File(filePath);
        if (await file.exists()) {
          file.delete();
        }
        debugPrint("myVideoList ==1==> ${myVideoList.length}");
        if (myVideoList.isEmpty) {
          await storage.delete(
              key: "${Constant.hawkVIDEOList}${Constant.userID}");
          return;
        }
        debugPrint("myVideoList ==2==> ${myVideoList.length}");
        await storage.write(
          key: "${Constant.hawkVIDEOList}${Constant.userID}",
          value: jsonEncode(myVideoList),
        );
        return;
      }
    }
  }

  setDownloadProgress(int progress) {
    dProgress = progress;
    if (dProgress == 100) {
      saveInSecureStorage();
    }
    notifyListeners();
    debugPrint('setDownloadProgress dProgress ==============> $dProgress');
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    dProgress = 0;
  }
}
