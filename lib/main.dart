// lib/main.dart

import '/page/main_screen.dart';
import 'package:flutter/material.dart';
import 'page/login_page.dart';
import 'page/signup_page.dart';

import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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