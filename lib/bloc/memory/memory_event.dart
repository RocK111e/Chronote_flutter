// lib/bloc/memory/memory_event.dart

import '../../models/memory.dart';
import 'package:image_picker/image_picker.dart'; 

abstract class MemoryEvent {}

class LoadMemories extends MemoryEvent {}

class AddMemory extends MemoryEvent {
  final Memory memory;
  final XFile? imageFile; 
  AddMemory(this.memory, {this.imageFile});
}

class UpdateMemory extends MemoryEvent {
  final Memory memory;
  final XFile? newImageFile;
  UpdateMemory(this.memory, {this.newImageFile});
}

class DeleteMemory extends MemoryEvent {
  final Memory memory;
  DeleteMemory(this.memory);
}

class FilterMemories extends MemoryEvent {
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? tags;
  final String? emoji;

  FilterMemories({
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.tags,
    this.emoji,
  });
}