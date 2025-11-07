import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../firebase/auth.dart'; 


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _remindersEnabled = true;
  String _selectedFrequency = 'Daily';
  String _selectedLanguage = 'English';
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildProfileCard(),
        const SizedBox(height: 16),
        _buildLanguageCard(),
        const SizedBox(height: 16),
        _buildRemindersCard(),
        const SizedBox(height: 16),
        _buildAccountCard(),
        const SizedBox(height: 16),
        // --- ADDED THIS NEW DANGER ZONE CARD ---
        _buildDangerZoneCard(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader() {
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
              'Manage your account and preferences',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return _buildCard(
      icon: Icons.person_outline,
      title: 'Profile',
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue,
          child: Text('JD',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: const Text('John Doe',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('john.doe@example.com',
            style: TextStyle(color: Colors.grey[400])),
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
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value!;
          });
        },
      ),
    );
  }

  Widget _buildRemindersCard() {
    return _buildCard(
      icon: Icons.notifications_none,
      title: 'Reminders',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Enable notifications',
                style: TextStyle(color: Colors.white)),
            subtitle: Text('Get reminded to write your daily entries',
                style: TextStyle(color: Colors.grey[400])),
            value: _remindersEnabled,
            onChanged: (value) {
              setState(() {
                _remindersEnabled = value;
              });
            },
            contentPadding: EdgeInsets.zero,
            activeTrackColor: Colors.blue.withOpacity(0.5),
            activeColor: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text('Frequency', style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedFrequency,
            items: ['Daily', 'Weekly', 'Monthly'],
            onChanged: (value) {
              setState(() {
                _selectedFrequency = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          Text('Time', style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 8),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: '08:00 PM'),
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration(suffixIcon: Icons.access_time),
            onTap: () {
              /* TODO: Show time picker */
            },
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: Colors.red),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  // --- NEW WIDGET FOR CRASHLYTICS TESTING ---
  Widget _buildDangerZoneCard() {
    return _buildCard(
      icon: Icons.warning_amber_rounded,
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Button 1: Native Crash (closes the app)
          TextButton.icon(
            label: const Text('Force Crash', style: TextStyle(color: Colors.red)),
            onPressed: () => FirebaseCrashlytics.instance.crash(),
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.red.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 12),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon, required String title, required Widget child}) {
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
                Text(title,
                    style: TextStyle(color: Colors.grey[400], fontSize: 16)),
              ],
            ),
            const Divider(height: 32),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      {required String value,
      required List<String> items,
      required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String itemValue) {
        return DropdownMenuItem<String>(
          value: itemValue,
          child: Text(itemValue),
        );
      }).toList(),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(),
      dropdownColor: const Color(0xFF2C2C2E),
    );
  }

  InputDecoration _inputDecoration({IconData? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: Colors.grey[400], size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}