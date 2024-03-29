// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dev.dart';
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
    apiKey: 'AIzaSyBbjeMRGPPLsgfOkpDtFkTlWj0mlZVEfGI',
    appId: '1:825955979349:android:634e018eea5139984884dc',
    messagingSenderId: '825955979349',
    projectId: 'tailormade-debug',
    databaseURL: 'https://tailormade-debug.firebaseio.com',
    storageBucket: 'tailormade-debug.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfcLDICnkmOCAx3l9Tg1hD5eBogrmtgX4',
    appId: '1:825955979349:ios:3f8c0f411c823bd8',
    messagingSenderId: '825955979349',
    projectId: 'tailormade-debug',
    databaseURL: 'https://tailormade-debug.firebaseio.com',
    storageBucket: 'tailormade-debug.appspot.com',
    androidClientId: '825955979349-34l4hfqdl1cf2frd7sb65768ej32l04u.apps.googleusercontent.com',
    iosClientId: '825955979349-llfp7aheo7il83p3ltltncfmi60bsbeg.apps.googleusercontent.com',
    iosBundleId: 'io.github.jogboms.tailormade.dev',
  );
}
