// lib/widgets/tile.dart

import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../page/memory_detail_page.dart';
import '../firebase/analytics.dart';
import '../utils/date_helper.dart';

class MemoryTile extends StatelessWidget {
  final Memory memory;

  const MemoryTile({
    super.key,
    required this.memory,
  });

  @override
  Widget build(BuildContext context) {
    final displayDate = DateHelper.formatDisplayDate(memory.date);

    return InkWell(
      onTap: () {
        analytics.logEvent(name: 'memory_tile_tapped');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemoryDetailPage(memory: memory),
          ),
        );
      },
      splashColor: Colors.blue.withOpacity(0.2),
      highlightColor: Colors.blue.withOpacity(0.1),
      child: Card(
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue, size: 16.0),
                      const SizedBox(width: 8.0),
                      // USE FORMATTED DATE HERE
                      Text(
                        displayDate, 
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  if (memory.emoji != null && memory.emoji!.isNotEmpty)
                    Text(
                      memory.emoji!,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'NotoColorEmoji',
                      ),
                    ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    style: TextStyle(color: Colors.grey[300], fontSize: 15.0, height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (memory.tags.isNotEmpty) ...[
                    const SizedBox(height: 16.0),
                    Row(
                      children: memory.tags.map((label) => _buildTag(label)).toList(),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
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