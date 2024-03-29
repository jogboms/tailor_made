// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.prod.dart';
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
    apiKey: 'AIzaSyCMpRzd1u83akc6kvCza0rBjsxFmUkf7TI',
    appId: '1:411406804353:android:bb6c31c0382b00e8',
    messagingSenderId: '411406804353',
    projectId: 'tailor-made-2018',
    databaseURL: 'https://tailor-made-2018.firebaseio.com',
    storageBucket: 'tailor-made-2018.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkWR4IUB8j2_lXegnUDJVvjbeNn8Btoks',
    appId: '1:411406804353:ios:bb6c31c0382b00e8',
    messagingSenderId: '411406804353',
    projectId: 'tailor-made-2018',
    databaseURL: 'https://tailor-made-2018.firebaseio.com',
    storageBucket: 'tailor-made-2018.appspot.com',
    androidClientId: '411406804353-46o33hm7ukh1jkrpbicgtuabsp3ilkuv.apps.googleusercontent.com',
    iosClientId: '411406804353-c9vnhao4j14ain2tltl5hf1qonndoeqr.apps.googleusercontent.com',
    iosBundleId: 'io.github.jogboms.tailormade',
  );
}
