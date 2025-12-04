// lib/page/main_screen.dart

import 'package:flutter/material.dart';
// BlocProvider is removed from here as it is now in main.dart
import 'home_page.dart';
import 'calendar_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
import 'edit_memory_page.dart';
import '../widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CalendarPage(),
    SearchPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Removed BlocProvider wrapper. 
    // It now uses the one provided by main.dart
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _pages.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditMemoryPage(),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}