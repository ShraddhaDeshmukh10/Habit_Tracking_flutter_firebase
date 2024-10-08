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
    apiKey: 'AIzaSyD9pIbQTrNBOpbl7oHioywk8aURluE4woI',
    appId: '1:619464328672:web:45558fd4314502f7a79785',
    messagingSenderId: '619464328672',
    projectId: 'habit03-b8f5d',
    authDomain: 'habit03-b8f5d.firebaseapp.com',
    storageBucket: 'habit03-b8f5d.appspot.com',
    measurementId: 'G-SLPHBQVK31',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzIUz_Ys8Mi8dkvSkTQRnnQvVHctGJaQQ',
    appId: '1:619464328672:android:24e1adf85555453ba79785',
    messagingSenderId: '619464328672',
    projectId: 'habit03-b8f5d',
    storageBucket: 'habit03-b8f5d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAaJOBTAiaWPwXAPRdpLmHqbVYoFL4NXXk',
    appId: '1:619464328672:ios:5b440605996589e2a79785',
    messagingSenderId: '619464328672',
    projectId: 'habit03-b8f5d',
    storageBucket: 'habit03-b8f5d.appspot.com',
    iosBundleId: 'com.example.habit03',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAaJOBTAiaWPwXAPRdpLmHqbVYoFL4NXXk',
    appId: '1:619464328672:ios:5b440605996589e2a79785',
    messagingSenderId: '619464328672',
    projectId: 'habit03-b8f5d',
    storageBucket: 'habit03-b8f5d.appspot.com',
    iosBundleId: 'com.example.habit03',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9pIbQTrNBOpbl7oHioywk8aURluE4woI',
    appId: '1:619464328672:web:bceacdb748d4be87a79785',
    messagingSenderId: '619464328672',
    projectId: 'habit03-b8f5d',
    authDomain: 'habit03-b8f5d.firebaseapp.com',
    storageBucket: 'habit03-b8f5d.appspot.com',
    measurementId: 'G-JXGPQTGBMD',
  );
}
