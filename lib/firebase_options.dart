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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6HY-G1WqV8fyC24Phxt0hLO3JSKaWei4',
    appId: '1:170761880293:android:98cca48494a4dcd5c18a0c',
    messagingSenderId: '170761880293',
    projectId: 'feed-you-ca52a',
    databaseURL: 'https://feed-you-ca52a-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'feed-you-ca52a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-tHvrbgY59-odn4du_VRQgDSqQDxMAdM',
    appId: '1:170761880293:ios:1283f3ceeb6bc589c18a0c',
    messagingSenderId: '170761880293',
    projectId: 'feed-you-ca52a',
    databaseURL: 'https://feed-you-ca52a-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'feed-you-ca52a.appspot.com',
    androidClientId: '170761880293-uf1urcjs1tr2nj0plotce4iqkpsad9lc.apps.googleusercontent.com',
    iosClientId: '170761880293-nl19ahdjum6sok309rptf07nu2pnt5rj.apps.googleusercontent.com',
    iosBundleId: 'com.example.feedYouFlutter',
  );
}
