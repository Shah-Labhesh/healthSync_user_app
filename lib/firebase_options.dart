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
    apiKey: 'AIzaSyCU3B240cyPmrKKdi3DyFLUGmVU_3pA1nk',
    appId: '1:860762438269:android:3fff8b4a57f2ef3753cf14',
    messagingSenderId: '860762438269',
    projectId: 'healthsync-978bd',
    storageBucket: 'healthsync-978bd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcU50vpiF3a2eKR5ruiWGsnNlf-WqCkRs',
    appId: '1:860762438269:ios:d9a32b2e2a43ec5b53cf14',
    messagingSenderId: '860762438269',
    projectId: 'healthsync-978bd',
    storageBucket: 'healthsync-978bd.appspot.com',
    androidClientId: '860762438269-ej1est19ovj4g1uktacs4cuj8gl3h0gv.apps.googleusercontent.com',
    iosClientId: '860762438269-5qi59jf75hpf7g56gpmt5soh8mo5uehu.apps.googleusercontent.com',
    iosBundleId: 'com.example.userMobileApp',
  );
}