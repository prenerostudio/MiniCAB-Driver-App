import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBkPNpPhCg1hVZ14GUWeGpxpSaIL-qPdbU",
            authDomain: "minicab-driver-404513.firebaseapp.com",
            projectId: "minicab-driver-404513",
            storageBucket: "minicab-driver-404513.appspot.com",
            messagingSenderId: "864049452046",
            appId: "1:864049452046:web:f4eca83fde56a4543d585f",
            measurementId: "G-XZ79D28PGK"));

  } else {
    await Firebase.initializeApp();
    // Turn off phone auth app verification.

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

  }
}
