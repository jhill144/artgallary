// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAyd7Fb6E9BCq2zR9mRo1RLwZCr1q4fL0w',
    appId: '1:731747223236:web:6c31ba294ebe3af9e36b91',
    messagingSenderId: '731747223236',
    projectId: 'gsu-mobileclass',
    authDomain: 'gsu-mobileclass.firebaseapp.com',
    storageBucket: 'gsu-mobileclass.appspot.com',
    measurementId: 'G-85W4W8HEVS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtvnaBHpJ0a8NEhUrF79RDjeDIKPuN9uY',
    appId: '1:731747223236:android:7f60fe3fb6b98e9ee36b91',
    messagingSenderId: '731747223236',
    projectId: 'gsu-mobileclass',
    storageBucket: 'gsu-mobileclass.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDM6QKDKgzAeKDe6NNzJ8Sb3lGW2XqzHU4',
    appId: '1:731747223236:ios:63272ac38b5f88bde36b91',
    messagingSenderId: '731747223236',
    projectId: 'gsu-mobileclass',
    storageBucket: 'gsu-mobileclass.appspot.com',
    iosBundleId: 'com.example.artgallary',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAyd7Fb6E9BCq2zR9mRo1RLwZCr1q4fL0w',
    appId: '1:731747223236:web:5f260756d20fb971e36b91',
    messagingSenderId: '731747223236',
    projectId: 'gsu-mobileclass',
    authDomain: 'gsu-mobileclass.firebaseapp.com',
    storageBucket: 'gsu-mobileclass.appspot.com',
    measurementId: 'G-C2FJ5ZLQ6S',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDM6QKDKgzAeKDe6NNzJ8Sb3lGW2XqzHU4',
    appId: '1:731747223236:ios:63272ac38b5f88bde36b91',
    messagingSenderId: '731747223236',
    projectId: 'gsu-mobileclass',
    storageBucket: 'gsu-mobileclass.appspot.com',
    iosBundleId: 'com.example.artgallary',
  );

}