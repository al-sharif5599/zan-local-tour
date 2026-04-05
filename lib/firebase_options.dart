import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDQCXQzZ-MnbEpJobPHTDxyD5B5wu3laNU',
    appId: '1:348700045749:web:REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: '348700045749',
    projectId: 'zan-local-tour',
    authDomain: 'zan-local-tour.firebaseapp.com',
    storageBucket: 'zan-local-tour.firebasestorage.app',
    measurementId: 'REPLACE_WITH_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQCXQzZ-MnbEpJobPHTDxyD5B5wu3laNU',
    appId: '1:348700045749:android:c0a2844a864e826fb469fc',
    messagingSenderId: '348700045749',
    projectId: 'zan-local-tour',
    storageBucket: 'zan-local-tour.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQCXQzZ-MnbEpJobPHTDxyD5B5wu3laNU',
    appId: '1:348700045749:ios:REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '348700045749',
    projectId: 'zan-local-tour',
    storageBucket: 'zan-local-tour.firebasestorage.app',
    iosBundleId: 'REPLACE_WITH_IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQCXQzZ-MnbEpJobPHTDxyD5B5wu3laNU',
    appId: '1:348700045749:ios:REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '348700045749',
    projectId: 'zan-local-tour',
    storageBucket: 'zan-local-tour.firebasestorage.app',
    iosBundleId: 'REPLACE_WITH_IOS_BUNDLE_ID',
  );
}
