// lib/page/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_state.dart';
import '../widgets/tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryBloc, MemoryState>(
      builder: (context, state) {
        // 1. Loading State
        if (state is MemoryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        // 2. Error State
        if (state is MemoryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // 3. Loaded State
        if (state is MemoryLoaded) {
          final memories = state.memories;

          if (memories.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            // Add +1 to count for the Header widget
            itemCount: memories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHomeHeader(memories.length);
              }
              // Access memory at index - 1 because index 0 is the header
              final memory = memories[index - 1];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: MemoryTile(memory: memory),
              );
            },
          );
        }

        return const SizedBox.shrink();
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHomeHeader(0), // Still show header
          const SizedBox(height: 40),
          Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'No memories yet',
            style: TextStyle(color: Colors.grey[500], fontSize: 18),
          ),
        ],
      ),
    );
  }
}