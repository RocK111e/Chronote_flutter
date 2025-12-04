// lib/main.dart

import 'package:event_diary2/firebase/analytics.dart';
import '/page/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'page/login_page.dart';
import 'page/signup_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'; 

import 'firebase_options.dart';
import 'data/memory_repository.dart'; // Import Repo
import 'bloc/memory/memory_bloc.dart'; // Import Bloc
import 'bloc/memory/memory_event.dart'; // Import Event

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // UPDATED: BlocProvider is now here at the top level
    return BlocProvider(
      create: (context) => MemoryBloc(MemoryRepository())..add(LoadMemories()),
      child: MaterialApp(
        title: 'Chronote',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const MainScreen(),
          '/signup': (context) => const SignUpPage(),
        },
      ),
    );
  }
}