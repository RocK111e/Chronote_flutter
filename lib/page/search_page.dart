// lib/page/search_page.dart

import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../widgets/tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _showFilters = true;

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Updated sample data to include an emoji
    const sampleResult = Memory(
      date: 'October 7, 2025 at 03:00 AM',
      content: 'Started reading a new book today called "The Midnight Library". Already 100 pages in and I can\'t put it down. The concept of parallel lives is fascina...',
      tags: ['books', 'coffee', 'relaxation'],
      emoji: '📚', // Added emoji for the result tile
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildSearchCard(),
        const SizedBox(height: 32),
        _buildResultsHeader(),
        const SizedBox(height: 16),
        MemoryTile(memory: sampleResult),
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
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Find your memories',
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

  Widget _buildSearchCard() {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchTextField(),
            const SizedBox(height: 16),
            _buildFilterToggleButton(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SizeTransition(sizeFactor: animation, child: child);
              },
              child: _showFilters ? _buildFilterSection() : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration('Search by text...', prefixIcon: Icons.search),
    );
  }

  Widget _buildFilterToggleButton() {
    return TextButton.icon(
      onPressed: _toggleFilters,
      icon: Icon(Icons.filter_list, color: Colors.grey[400], size: 20),
      label: Text(
        _showFilters ? 'Hide Filters' : 'Show Filters',
        style: TextStyle(color: Colors.grey[400]),
      ),
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text('Filter by Tags', style: TextStyle(color: Colors.grey[400])),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Enter tags separated by commas...'),
        ),
        
        const SizedBox(height: 16),
        Text('Filter by Emoji', style: TextStyle(color: Colors.grey[400])),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Enter an emoji...', prefixIcon: Icons.emoji_emotions_outlined),
        ),
        

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start Date', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('10.09.2025', suffixIcon: Icons.calendar_today_outlined),
                    onTap: () { /* TODO: Show date picker */ },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('End Date', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('10.12.2025', suffixIcon: Icons.calendar_today_outlined),
                    onTap: () { /* TODO: Show date picker */ },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          child: Text('Clear All Filters', style: TextStyle(color: Colors.grey[400])),
        ),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return const Text(
      '1 result',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, {IconData? prefixIcon, IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey.withValues(alpha: 0.1),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[400], size: 20) : null,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey[400], size: 20) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}