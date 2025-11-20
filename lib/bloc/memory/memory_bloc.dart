import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/memory.dart';
import '../../data/memory_repository.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final MemoryRepository _repository;
  List<Memory> _allMemories = [];

  MemoryBloc(this._repository) : super(MemoryLoading()) {
    on<LoadMemories>(_onLoadMemories);
    on<FilterMemories>(_onFilterMemories);
  }

  Future<void> _onLoadMemories(
    LoadMemories event,
    Emitter<MemoryState> emit,
  ) async {
    emit(MemoryLoading());
    try {
      _allMemories = await _repository.getMemories();
      emit(MemoryLoaded(_allMemories));
    } catch (e) {
      emit(MemoryError("Failed to load memories"));
    }
  }

  void _onFilterMemories(
    FilterMemories event,
    Emitter<MemoryState> emit,
  ) {
    List<Memory> filtered = _allMemories.where((memory) {
      // 1. Filter by Text Content
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        if (!memory.content.toLowerCase().contains(event.searchQuery!.toLowerCase())) {
          return false;
        }
      }

      // 2. Filter by Emoji
      if (event.emoji != null && event.emoji!.isNotEmpty) {
        if (memory.emoji != event.emoji) {
          return false;
        }
      }

      // 3. Filter by Tags
      if (event.tags != null && event.tags!.isNotEmpty) {
        bool hasMatchingTag = false;
        for (var tag in event.tags!) {
          if (memory.tags.contains(tag)) {
            hasMatchingTag = true;
            break;
          }
        }
        if (!hasMatchingTag) return false;
      }

      // 4. Filter by Date Range
      if (event.startDate != null || event.endDate != null) {
        final DateTime? memDate = _repository.parseDate(memory.date);
        
        if (memDate != null) {
          // Check Start Date (ignoring time, comparing start of day)
          if (event.startDate != null) {
            final start = DateTime(event.startDate!.year, event.startDate!.month, event.startDate!.day);
             // We compare assuming the memory date is strictly after or equal to start
            if (memDate.isBefore(start)) {
              return false;
            }
          }

          // Check End Date (set to end of that day)
          if (event.endDate != null) {
            final end = DateTime(event.endDate!.year, event.endDate!.month, event.endDate!.day, 23, 59, 59);
            if (memDate.isAfter(end)) {
              return false;
            }
          }
        }
      }

      return true;
    }).toList();

    emit(MemoryLoaded(filtered));
  }
}