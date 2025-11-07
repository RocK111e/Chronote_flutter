// lib/page/calendar_page.dart

import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../widgets/tile.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    const sampleMemory = Memory(
      date: 'October 5, 2025 at 03:00 AM',
      content: 'Family dinner tonight was wonderful. Mom made her famous lasagna and we spent hours just talking and laughing together. These moments are so precious....',
      tags: ['family', 'food', 'gratitude'],
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildCalendarView(),
        const SizedBox(height: 32),
        _buildEntriesForDateHeader(),
        const SizedBox(height: 16),
        MemoryTile(
          memory: sampleMemory,
        ),
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
              'Calendar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'View your memories by date',
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

  Widget _buildCalendarView() {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendarHeader(),
            const SizedBox(height: 24),
            _buildWeekdays(),
            const SizedBox(height: 16),
            _buildDaysGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {},
        ),
        const Text(
          'October 2025',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWeekdays() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) => Text(day, style: TextStyle(color: Colors.grey[600]))).toList(),
    );
  }

  Widget _buildDaysGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: 31, 
      itemBuilder: (context, index) {
        final day = index + 1;
        if (day == 5) return _buildDayCell(day.toString(), isSelected: true);
        if (day == 3 || day == 7 || day == 8) return _buildDayCell(day.toString(), hasEntry: true);
        return _buildDayCell(day.toString());
      },
    );
  }

  Widget _buildDayCell(String day, {bool isSelected = false, bool hasEntry = false}) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : (hasEntry ? Colors.grey[800] : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[300],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (hasEntry) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesForDateHeader() {
    return const Text(
      'Entries for October 5, 2025',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}