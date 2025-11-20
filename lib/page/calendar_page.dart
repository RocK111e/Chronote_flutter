// lib/page/calendar_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_state.dart';
import '../models/memory.dart';
import '../utils/date_helper.dart';
import '../widgets/tile.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryBloc, MemoryState>(
      builder: (context, state) {
        List<Memory> allMemories = [];
        if (state is MemoryLoaded) {
          allMemories = state.memories;
        }

        // Filter memories for the selected day
        final selectedDayMemories = allMemories.where((memory) {
          final date = DateHelper.parse(memory.date);
          return DateHelper.isSameDay(date, _selectedDay);
        }).toList();

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildCalendarView(allMemories),
            const SizedBox(height: 32),
            _buildEntriesForDateHeader(),
            const SizedBox(height: 16),
            if (selectedDayMemories.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No entries for this day",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ...selectedDayMemories.map((memory) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MemoryTile(memory: memory),
                  )),
            const SizedBox(height: 80), // Bottom padding
          ],
        );
      },
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

  Widget _buildCalendarView(List<Memory> memories) {
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
            _buildDaysGrid(memories),
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
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(_focusedDay),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
            });
          },
        ),
      ],
    );
  }

  Widget _buildWeekdays() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((day) =>
              Text(day, style: TextStyle(color: Colors.grey[600])))
          .toList(),
    );
  }

  Widget _buildDaysGrid(List<Memory> memories) {
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    // Calculate total slots needed (padding + days)
    final totalSlots = startingWeekday + daysInMonth;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < startingWeekday) {
          return const SizedBox.shrink();
        }

        final day = index - startingWeekday + 1;
        final date = DateTime(_focusedDay.year, _focusedDay.month, day);

        // Check if this date has any memory
        final hasEntry = memories.any((m) {
          final mDate = DateHelper.parse(m.date);
          return DateHelper.isSameDay(mDate, date);
        });

        final isSelected = DateHelper.isSameDay(date, _selectedDay);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = date;
            });
          },
          child: _buildDayCell(day.toString(),
              isSelected: isSelected, hasEntry: hasEntry),
        );
      },
    );
  }

  Widget _buildDayCell(String day,
      {bool isSelected = false, bool hasEntry = false}) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blue
            : (hasEntry ? Colors.grey[800] : Colors.transparent),
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
            if (hasEntry && !isSelected) ...[
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
    return Text(
      'Entries for ${DateFormat('MMMM d, yyyy').format(_selectedDay)}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}