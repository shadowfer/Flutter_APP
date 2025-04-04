// Importa la clase FirebaseOptions de firebase_core
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// Importa funciones y constantes para detectar la plataforma
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// Clase que proporciona las opciones de configuración de Firebase según la plataforma
class DefaultFirebaseOptions {
  // Método getter que devuelve las opciones correctas según la plataforma en ejecución
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Si la app está ejecutándose en web, devuelve la configuración web
      return web;
    }

    // Switch para determinar la plataforma móvil
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android; // Devuelve configuración para Android
      case TargetPlatform.iOS:
        return ios; // Devuelve configuración para iOS
      default:
        // Lanza un error si la plataforma no es compatible
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Opciones de configuración para la plataforma web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey:
        'AIzaSyBrvY0oy_L1m0bRL6Wv7l0x62zPsf3yq6I', // Clave API para acceder a Firebase
    appId: '1:822384418639:web:822384418639', // ID único de la app en Firebase
    messagingSenderId: '822384418639', // ID para Firebase Cloud Messaging
    projectId: 'foodgo-a64a0', // ID del proyecto en Firebase
    authDomain: 'foodgo-a64a0.firebaseapp.com', // Dominio para autenticación
    storageBucket: 'foodgo-a64a0.appspot.com', // Bucket para almacenamiento
  );

  // Opciones de configuración para Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrvY0oy_L1m0bRL6Wv7l0x62zPsf3yq6I', // Clave API
    appId:
        '1:822384418639:android:6f461bc9eb9840a9d7ef3a', // ID de app para Android
    messagingSenderId: '822384418639', // ID para mensajería
    projectId: 'foodgo-a64a0', // ID del proyecto
    storageBucket: 'foodgo-a64a0.appspot.com', // Bucket de almacenamiento
  );

  // Opciones de configuración para iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyXXXXXXXXXXXXXXXXXXXXX', // Clave API placeholder
    appId: '1:822384418639:ios:XXXXXXXXXXXXXXXX', // ID de app placeholder
    messagingSenderId: '822384418639', // ID para mensajería
    projectId: 'foodgo-a64a0', // ID del proyecto
    storageBucket: 'foodgo-a64a0.appspot.com', // Bucket de almacenamiento
    iosClientId:
        'XXXXXXXXXXXXXXXX.apps.googleusercontent.com', // ID cliente para iOS (placeholder)
    iosBundleId: 'com.example.restauranteApp', // Bundle ID de la app iOS
  );
}
