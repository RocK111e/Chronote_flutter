// lib/page/settings_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../firebase/auth.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _remindersEnabled = true;
  String _selectedLanguage = 'English';
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildLanguageCard(),
        const SizedBox(height: 16),
        _buildRemindersCard(),
        const SizedBox(height: 16),
        _buildAccountCard(),
        const SizedBox(height: 16),
        _buildDangerZoneCard(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Guest';

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              email,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18.0, 
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return _buildCard(
      icon: Icons.language,
      title: 'Language',
      child: _buildDropdown(
        value: _selectedLanguage,
        items: ['English', 'Ukrainian', 'Spanish'],
        onChanged: (value) => setState(() => _selectedLanguage = value!),
      ),
    );
  }

  Widget _buildRemindersCard() {
    return _buildCard(
      icon: Icons.notifications_none,
      title: 'Reminders',
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable notifications', style: TextStyle(color: Colors.white)),
            subtitle: Text('Get reminded daily', style: TextStyle(color: Colors.grey[400])),
            value: _remindersEnabled,
            onChanged: (val) => setState(() => _remindersEnabled = val),
            activeColor: Colors.blue,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return _buildCard(
      icon: Icons.logout,
      title: 'Account',
      child: TextButton.icon(
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Log Out', style: TextStyle(color: Colors.red)),
        onPressed: () {
          _authService.signOut();
          Navigator.of(context).pushReplacementNamed('/');
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14), 
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return _buildCard(
      icon: Icons.warning_amber_rounded,
      title: 'Danger Zone',
      child: TextButton(
        onPressed: () => FirebaseCrashlytics.instance.crash(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14), 
          side: BorderSide(color: Colors.red.withOpacity(0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: const Text('Force Crash', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required Widget child}) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey[400]), 
                const SizedBox(width: 12), 
                Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 16))
              ]
            ),
            const Divider(height: 32),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      dropdownColor: const Color(0xFF2C2C2E),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}