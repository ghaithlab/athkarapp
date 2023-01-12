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
    apiKey: 'AIzaSyCFC7gX86egsb0XylptaZXqWNTm14EK7pI',
    appId: '1:306418123724:web:c3bf0defa1262c0ce65369',
    messagingSenderId: '306418123724',
    projectId: 'muslimshabits',
    authDomain: 'muslimshabits.firebaseapp.com',
    storageBucket: 'muslimshabits.appspot.com',
    measurementId: 'G-CLTYTFETFR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7gQm9fcOQl1P2uyBqcrLTlxFWLwWj05Q',
    appId: '1:306418123724:android:30162dc3424022fee65369',
    messagingSenderId: '306418123724',
    projectId: 'muslimshabits',
    storageBucket: 'muslimshabits.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQXzfPY4HZ_VG3fV9MLIRfX7nty-eL8O8',
    appId: '1:306418123724:ios:9bc76eb27e5253cbe65369',
    messagingSenderId: '306418123724',
    projectId: 'muslimshabits',
    storageBucket: 'muslimshabits.appspot.com',
    iosClientId: '306418123724-ad6h3attvhkngikc8tp4oi1djn1urm8l.apps.googleusercontent.com',
    iosBundleId: 'com.labisoft.athkar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQXzfPY4HZ_VG3fV9MLIRfX7nty-eL8O8',
    appId: '1:306418123724:ios:883edaa3ae2ba35ae65369',
    messagingSenderId: '306418123724',
    projectId: 'muslimshabits',
    storageBucket: 'muslimshabits.appspot.com',
    iosClientId: '306418123724-r111qe7igvr3op2pfh7dinfpfs40rqrl.apps.googleusercontent.com',
    iosBundleId: 'com.example.athkarapp',
  );
}