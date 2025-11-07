// lib/page/memory_detail_page.dart

import 'package:flutter/material.dart';
import '../models/memory.dart';

class MemoryDetailPage extends StatelessWidget {
  final Memory memory;

  const MemoryDetailPage({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
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
                  Text('Back to Home', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () { /* TODO: Implement edit functionality */ },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () { /* TODO: Implement delete functionality */ },
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
              mainAxisSize: MainAxisSize.min, // Make card wrap content
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blue, size: 16.0),
                    const SizedBox(width: 8.0),
                    Text(
                      memory.date, // Use data from the memory object
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                if (memory.imagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          memory.imagePath!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 200,
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
}
