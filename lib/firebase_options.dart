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
    apiKey: 'AIzaSyAEW8-oVpE_-LjhZ9iq4kWON2ERfojYLJk',
    appId: '1:709959871971:web:6bd6bb63cbb72e4e5c84d6',
    messagingSenderId: '709959871971',
    projectId: 'ether-app---reddit-clone',
    authDomain: 'ether-app---reddit-clone.firebaseapp.com',
    storageBucket: 'ether-app---reddit-clone.appspot.com',
    measurementId: 'G-ZWR0DNC25N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjvHHEdnR3kE8Dcdsmt2vuHZW6ytHM5Cc',
    appId: '1:709959871971:android:6ce96ab00038d0465c84d6',
    messagingSenderId: '709959871971',
    projectId: 'ether-app---reddit-clone',
    storageBucket: 'ether-app---reddit-clone.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_FxI8fxak3cpMOuS6XBVXtUgUUwO7nj0',
    appId: '1:709959871971:ios:612472f23c9ed6785c84d6',
    messagingSenderId: '709959871971',
    projectId: 'ether-app---reddit-clone',
    storageBucket: 'ether-app---reddit-clone.appspot.com',
    iosBundleId: 'com.example.etherApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_FxI8fxak3cpMOuS6XBVXtUgUUwO7nj0',
    appId: '1:709959871971:ios:909c7576e8b99f4e5c84d6',
    messagingSenderId: '709959871971',
    projectId: 'ether-app---reddit-clone',
    storageBucket: 'ether-app---reddit-clone.appspot.com',
    iosBundleId: 'com.example.etherApp.RunnerTests',
  );
}
