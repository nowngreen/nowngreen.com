// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBb-hTxrIyQTbQCENkTi7lJ5-7fzc5DR2A',
    appId: '1:907048035174:web:d3c4faf16db048c9561ea7',
    messagingSenderId: '907048035174',
    projectId: 'appngreen',
    authDomain: 'appngreen.firebaseapp.com',
    storageBucket: 'appngreen.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoyogxS-riRLTAJKowpqEqlnK4A5kh4ao',
    appId: '1:907048035174:android:35e019c3090f63b9561ea7',
    messagingSenderId: '907048035174',
    projectId: 'appngreen',
    storageBucket: 'appngreen.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPPbsQhU6v_xarnfB6yl8LmKioUPNuyDw',
    appId: '1:907048035174:ios:ab48f26064d31fc3561ea7',
    messagingSenderId: '907048035174',
    projectId: 'appngreen',
    storageBucket: 'appngreen.appspot.com',
    androidClientId: '907048035174-r1bbnra96dqr76qkeob108gv68v5j3v3.apps.googleusercontent.com',
    iosClientId: '907048035174-h47smt1g8camrtdoqvk6rrkttc8r6rqf.apps.googleusercontent.com',
    iosBundleId: 'com.divinetechs.dtliveapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPPbsQhU6v_xarnfB6yl8LmKioUPNuyDw',
    appId: '1:907048035174:ios:ab48f26064d31fc3561ea7',
    messagingSenderId: '907048035174',
    projectId: 'appngreen',
    storageBucket: 'appngreen.appspot.com',
    androidClientId: '907048035174-r1bbnra96dqr76qkeob108gv68v5j3v3.apps.googleusercontent.com',
    iosClientId: '907048035174-h47smt1g8camrtdoqvk6rrkttc8r6rqf.apps.googleusercontent.com',
    iosBundleId: 'com.divinetechs.dtliveapp',
  );
}