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
    apiKey: 'AIzaSyCAGnBnyo9J0mthJYNh9qkmLWCZ10cZkZQ',
    appId: '1:63862180399:web:9dda667505690d43b394da',
    messagingSenderId: '63862180399',
    projectId: 'perpusgo-824d1',
    authDomain: 'perpusgo-824d1.firebaseapp.com',
    storageBucket: 'perpusgo-824d1.appspot.com',
    measurementId: 'G-WGM4E8GCH2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCi0An4i0TnelsLkaJCmnV6N-ycSSzuD74',
    appId: '1:63862180399:android:7b03869bd9f53148b394da',
    messagingSenderId: '63862180399',
    projectId: 'perpusgo-824d1',
    storageBucket: 'perpusgo-824d1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAp6ZB7nlFrxOATmRuysvSGcSSFL1c3Tw',
    appId: '1:63862180399:ios:76feb2a2253dbce0b394da',
    messagingSenderId: '63862180399',
    projectId: 'perpusgo-824d1',
    storageBucket: 'perpusgo-824d1.appspot.com',
    androidClientId: '63862180399-dpgv8jnbnbj4c94mse2628467iac3kns.apps.googleusercontent.com',
    iosClientId: '63862180399-ute3450gi57iing9gupmsua25lg6lqmt.apps.googleusercontent.com',
    iosBundleId: 'com.example.perpusgo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAp6ZB7nlFrxOATmRuysvSGcSSFL1c3Tw',
    appId: '1:63862180399:ios:a176e79fd7281f4cb394da',
    messagingSenderId: '63862180399',
    projectId: 'perpusgo-824d1',
    storageBucket: 'perpusgo-824d1.appspot.com',
    androidClientId: '63862180399-dpgv8jnbnbj4c94mse2628467iac3kns.apps.googleusercontent.com',
    iosClientId: '63862180399-bi4aakoe7h51lrkd558kmkfs0q03h8l5.apps.googleusercontent.com',
    iosBundleId: 'com.example.perpusgo.RunnerTests',
  );
}
