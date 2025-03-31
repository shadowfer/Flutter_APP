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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey:
        'AIzaSyBrvY0oy_L1m0bRL6Wv7l0x62zPsf3yq6I', // Reemplaza con tu apiKey
    appId: '1:822384418639:web:822384418639', // Reemplaza con tu appId
    messagingSenderId: '822384418639', // Tu messagingSenderId
    projectId: 'foodgo-a64a0', // Tu projectId
    authDomain: 'foodgo-a64a0.firebaseapp.com',
    storageBucket: 'foodgo-a64a0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'AIzaSyBrvY0oy_L1m0bRL6Wv7l0x62zPsf3yq6I', // Reemplaza con tu apiKey
    appId:
        '1:822384418639:android:6f461bc9eb9840a9d7ef3a', // Reemplaza con tu appId
    messagingSenderId: '822384418639', // Tu messagingSenderId
    projectId: 'foodgo-a64a0', // Tu projectId
    storageBucket: 'foodgo-a64a0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyXXXXXXXXXXXXXXXXXXXXX', // Reemplaza con tu apiKey
    appId: '1:822384418639:ios:XXXXXXXXXXXXXXXX', // Reemplaza con tu appId
    messagingSenderId: '822384418639', // Tu messagingSenderId
    projectId: 'foodgo-a64a0', // Tu projectId
    storageBucket: 'foodgo-a64a0.appspot.com',
    iosClientId:
        'XXXXXXXXXXXXXXXX.apps.googleusercontent.com', // Reemplaza con tu iosClientId
    iosBundleId: 'com.example.restauranteApp',
  );
}
