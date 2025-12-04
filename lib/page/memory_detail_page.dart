// lib/page/memory_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../models/memory.dart';
import '../utils/date_helper.dart';
import 'edit_memory_page.dart';

class MemoryDetailPage extends StatelessWidget {
  final Memory memory;

  const MemoryDetailPage({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final displayDate = DateHelper.formatDisplayDate(memory.date);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Back', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMemoryPage(memory: memory),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blue, size: 16.0),
                    const SizedBox(width: 8.0),
                    Text(
                      displayDate, 
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    const Spacer(),
                    if (memory.emoji != null && memory.emoji!.isNotEmpty)
                      Text(
                        memory.emoji!,
                        style: const TextStyle(
                          fontSize: 24.0, 
                          fontFamily: 'NotoColorEmoji',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16.0),
                
                // Display Image from Network (Firestore Storage)
                if (memory.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          memory.imageUrl!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 200,
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (ctx, error, stack) => 
                            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),

                Text(
                  memory.content,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0, height: 1.5),
                ),
                if (memory.tags.isNotEmpty) ...[
                  const SizedBox(height: 24.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: memory.tags.map((label) => _buildTag(label)).toList(),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.blue, fontSize: 12.0),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Memory?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              context.read<MemoryBloc>().add(DeleteMemory(memory.id!));
              Navigator.pop(context); // Go back to list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}