import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: "AIzaSyAjF6Z92cfx1PN6un1tKevakCjx7Yf0eio",
      // authDomain: "minicab-driver-404513.firebaseapp.com",
      projectId: "new-mini-cab-driver",
      // storageBucket: "minicab-driver-404513.appspot.com",
      messagingSenderId: "746952981784",
      appId: "1:746952981784:android:a5ea79e652001f1547b26d",
      // measurementId: "G-XZ79D28PGK"
    ));
  } else {
    await Firebase.initializeApp();
    // Turn off phone auth app verification.

    // await FirebaseAppCheck.instance.activate(
    //   androidProvider: AndroidProvider.playIntegrity,
    //   appleProvider: AppleProvider.appAttest,
    // );
  }
}
