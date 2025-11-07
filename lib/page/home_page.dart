// lib/page/home_page.dart

import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../widgets/tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Memory> memories = const [
  Memory(
    date: 'Tuesday, October 8, 2025 at 03:00 AM',
    content: 'Today was an incredible day! I went hiking...',
    tags: ['hiking', 'nature', 'adventure'],
    emoji: '⛰️',
  ),
  Memory(
    date: 'Monday, October 7, 2025 at 03:00 AM',
    content: 'Started reading a new book today...',
    imagePath: 'lib/mock/image.png',
    tags: ['books', 'coffee', 'relaxation'],
    emoji: '📚',
  ),
  Memory(
    date: 'Sunday, October 6, 2025 at 10:00 PM',
    content: 'Just a simple note for today.',
  ),
];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: memories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHomeHeader(memories.length);
        }
        final memory = memories[index - 1];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: MemoryTile(memory: memory),
        );
      },
    );
  }

  Widget _buildHomeHeader(int entryCount) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Memories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '$entryCount entries',
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
}