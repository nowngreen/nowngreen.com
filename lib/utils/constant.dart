import 'package:nowlive/model/qualitymodel.dart';
import 'package:nowlive/model/subtitlemodel.dart';

class Constant {
  static const String baseurl = 'https://nowngreen.com/admin_panel/public/api/';

  static String appName = "Nowngreen";
  static String appPackageName = "com.nowngreen.app";
  static String appleAppId = "6449380090";

  /* OneSignal App ID */
  static const String oneSignalAppId = "";

  /* Constant for TV check */
  static bool isTV = false;

  static String? userID;
  static String currencySymbol = "";
  static String currency = "";

  static String androidAppShareUrlDesc =
      "Let me recommend you this application\n\n$androidAppUrl";
  static String iosAppShareUrlDesc =
      "Let me recommend you this application\n\n$iosAppUrl";

  static String androidAppUrl =
      "https://play.google.com/store/apps/details?id=${Constant.appPackageName}";
  static String iosAppUrl =
      "https://apps.apple.com/us/app/id${Constant.appleAppId}";

  static List<QualityModel> resolutionsUrls = [];
  static List<SubTitleModel> subtitleUrls = [];

  /* Download config */
  static String videoDownloadPort = 'video_downloader_send_port';
  static String showDownloadPort = 'show_downloader_send_port';
  static String hawkVIDEOList = "myVideoList_";
  static String hawkKIDSVIDEOList = "myKidsVideoList_";
  static String hawkSHOWList = "myShowList_";
  static String hawkSEASONList = "mySeasonList_";
  static String hawkEPISODEList = "myEpisodeList_";
  /* Download config */

  static int fixFourDigit = 1317;
  static int fixSixDigit = 161613;

  static int bannerDuration = 10000; // in milliseconds
  static int animationDuration = 800; // in milliseconds

  /* Show Ad By Type */
  static String rewardAdType = "rewardAd";
  static String interstialAdType = "interstialAd";
}
