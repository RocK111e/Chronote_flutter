// lib/page/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this
import '../data/memory_repository.dart'; // Add this
import '../bloc/memory/memory_bloc.dart'; // Add this
import '../bloc/memory/memory_event.dart'; // Add this
import 'home_page.dart';
import 'calendar_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
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
    // Wrap the Scaffold in BlocProvider to make MemoryBloc available to all pages
    return BlocProvider(
      create: (context) => MemoryBloc(MemoryRepository())..add(LoadMemories()),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: _pages.elementAt(_selectedIndex),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  // Logic to add new memory will go here later
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        bottomNavigationBar: NavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}