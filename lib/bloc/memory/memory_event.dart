// lib/bloc/memory/memory_event.dart

import '../../models/memory.dart';

abstract class MemoryEvent {}

class LoadMemories extends MemoryEvent {}

class AddMemory extends MemoryEvent {
  final Memory memory;
  final dynamic imageFile; // File object (Platform dependent)
  AddMemory(this.memory, {this.imageFile});
}

class UpdateMemory extends MemoryEvent {
  final Memory memory;
  final dynamic newImageFile;
  UpdateMemory(this.memory, {this.newImageFile});
}

class DeleteMemory extends MemoryEvent {
  final String id;
  DeleteMemory(this.id);
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