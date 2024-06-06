import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:nowlive/firebase_options.dart';
import 'package:nowlive/pages/splash.dart';
import 'package:nowlive/provider/avatarprovider.dart';
import 'package:nowlive/provider/castdetailsprovider.dart';
import 'package:nowlive/provider/channelsectionprovider.dart';
import 'package:nowlive/provider/showdownloadprovider.dart';
import 'package:nowlive/provider/subhistoryprovider.dart';
import 'package:nowlive/provider/videodownloadprovider.dart';
import 'package:nowlive/provider/episodeprovider.dart';
import 'package:nowlive/provider/findprovider.dart';
import 'package:nowlive/provider/generalprovider.dart';
import 'package:nowlive/provider/homeprovider.dart';
import 'package:nowlive/provider/paymentprovider.dart';
import 'package:nowlive/provider/playerprovider.dart';
import 'package:nowlive/provider/profileprovider.dart';
import 'package:nowlive/provider/purchaselistprovider.dart';
import 'package:nowlive/provider/rentstoreprovider.dart';
import 'package:nowlive/provider/searchprovider.dart';
import 'package:nowlive/provider/sectionbytypeprovider.dart';
import 'package:nowlive/provider/sectiondataprovider.dart';
import 'package:nowlive/provider/showdetailsprovider.dart';
import 'package:nowlive/provider/subscriptionprovider.dart';
import 'package:nowlive/provider/videobyidprovider.dart';
import 'package:nowlive/provider/videodetailsprovider.dart';
import 'package:nowlive/provider/watchlistprovider.dart';
import 'package:nowlive/tvpages/tvhome.dart';
import 'package:nowlive/utils/color1.dart';
import 'package:nowlive/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await FlutterDownloader.initialize();
    await MobileAds.instance.initialize();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Locales.init([
    'en',
    'af',
    'ar',
    'de',
    'es',
    'fr',
    'gu',
    'hi',
    'id',
    'nl',
    'pt',
    'sq',
    'tr',
    'vi'
  ]);

  // if (!kIsWeb) {
  //   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  //   // Initialize OneSignal
  //   OneSignal.initialize(Constant.oneSignalAppId);
  //   OneSignal.Notifications.requestPermission(true);
  //   OneSignal.Notifications.addPermissionObserver((state) {
  //     debugPrint("Has permission ==> $state");
  //   });
  //   OneSignal.User.pushSubscription.addObserver((state) {
  //     debugPrint(
  //         "pushSubscription state ==> ${state.current.jsonRepresentation()}");
  //   });
  //   OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  //     /// preventDefault to not display the notification
  //     event.preventDefault();
  //     // Do async work
  //     /// notification.display() to display after preventing default
  //     event.notification.display();
  //   });
  // }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AvatarProvider()),
        ChangeNotifierProvider(create: (_) => CastDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ChannelSectionProvider()),
        ChangeNotifierProvider(create: (_) => EpisodeProvider()),
        ChangeNotifierProvider(create: (_) => FindProvider()),
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PurchaselistProvider()),
        ChangeNotifierProvider(create: (_) => RentStoreProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SectionByTypeProvider()),
        ChangeNotifierProvider(create: (_) => SectionDataProvider()),
        ChangeNotifierProvider(create: (_) => ShowDownloadProvider()),
        ChangeNotifierProvider(create: (_) => ShowDetailsProvider()),
        ChangeNotifierProvider(create: (_) => SubHistoryProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => VideoByIDProvider()),
        ChangeNotifierProvider(create: (_) => VideoDetailsProvider()),
        ChangeNotifierProvider(create: (_) => VideoDownloadProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // if (!kIsWeb) Utils.enableScreenCapture();
    if (!kIsWeb) _getDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: LocaleBuilder(
        builder: (locale) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver], //HERE
          theme: ThemeData(
            primaryColor: colorPrimary,
            primaryColorDark: colorPrimaryDark,
            primaryColorLight: primaryLight,
            scaffoldBackgroundColor: appBgColor,
          ).copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(
              thumbColor: MaterialStateProperty.all(white),
              trackVisibility: MaterialStateProperty.all(true),
              trackColor: MaterialStateProperty.all(whiteTransparent),
            ),
          ),
          title: Constant.appName,
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supportedLocales) {
            return locale;
          },
          builder: (context, child) {
            return ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 360, name: MOBILE),
                const Breakpoint(start: 361, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1000, name: DESKTOP),
                const Breakpoint(start: 1001, end: double.infinity, name: '4K'),
              ],
            );
          },
          home: (kIsWeb) ? const TVHome(pageName: "") : const Splash(),
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
              PointerDeviceKind.trackpad
            },
          ),
        ),
      ),
    );
  }

  _getDeviceInfo() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Constant.isTV =
          androidInfo.systemFeatures.contains('android.software.leanback');
      debugPrint("isTV =======================> ${Constant.isTV}");
    }
  }
}
