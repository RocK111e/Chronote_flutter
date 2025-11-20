// lib/main.dart

import 'package:event_diary2/firebase/analytics.dart';
import '/page/main_screen.dart';
import 'package:flutter/material.dart';
import 'page/login_page.dart';
import 'page/signup_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb and defaultTargetPlatform

// 1. Import the generated options file
import 'firebase_options.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Pass the options to initializeApp
  // This fixes the "FirebaseOptions cannot be null" error on Web and Linux
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Wrap Crashlytics in a check. 
  // Crashlytics is NOT supported on Web and will crash your app if you try to use it there.
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Analytics is supported on Web, so this is fine to leave outside the check
  await analytics.setAnalyticsCollectionEnabled(true);

  await analytics.logEvent(
    name: 'test_event'
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const MainScreen(),
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}