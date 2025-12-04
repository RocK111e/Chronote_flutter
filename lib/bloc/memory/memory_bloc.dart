// lib/bloc/memory/memory_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; 
import '../../models/memory.dart';
import '../../data/memory_repository.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final MemoryRepository _repository;
  List<Memory> _allMemories = [];

  MemoryBloc(this._repository) : super(MemoryLoading()) {
    on<LoadMemories>(_onLoadMemories);
    on<AddMemory>(_onAddMemory);
    on<UpdateMemory>(_onUpdateMemory);
    on<DeleteMemory>(_onDeleteMemory);
    on<FilterMemories>(_onFilterMemories);
  }

  Future<void> _onLoadMemories(LoadMemories event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());
    try {
      _allMemories = await _repository.getMemories();
      emit(MemoryLoaded(_allMemories));
    } catch (e) {
      emit(MemoryError("Failed to load memories: $e"));
    }
  }

  Future<void> _onAddMemory(AddMemory event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());
    try {
      String? imageUrl = event.memory.imageUrl;
      
      if (event.imageFile != null) {
        imageUrl = await _repository.uploadImage(event.imageFile!);
      }

      final newMemory = event.memory.copyWith(imageUrl: imageUrl);
      await _repository.addMemory(newMemory);
      add(LoadMemories()); 
    } catch (e) {
      emit(MemoryError("Failed to add memory: $e"));
    }
  }

  Future<void> _onUpdateMemory(UpdateMemory event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());
    try {
      String? imageUrl = event.memory.imageUrl;

      if (event.newImageFile != null) {
        imageUrl = await _repository.uploadImage(event.newImageFile!);
      }

      final updatedMemory = event.memory.copyWith(imageUrl: imageUrl);
      await _repository.updateMemory(updatedMemory);
      add(LoadMemories()); 
    } catch (e) {
      emit(MemoryError("Failed to update memory: $e"));
    }
  }

  // UPDATED: Handles deleting image + doc
  Future<void> _onDeleteMemory(DeleteMemory event, Emitter<MemoryState> emit) async {
    try {
      // Pass the whole memory object to repo
      await _repository.deleteMemory(event.memory);
      
      // Optimistic update
      _allMemories.removeWhere((m) => m.id == event.memory.id);
      emit(MemoryLoaded(List.from(_allMemories)));
      
      add(LoadMemories());
    } catch (e) {
      emit(MemoryError("Failed to delete memory"));
    }
  }

  void _onFilterMemories(FilterMemories event, Emitter<MemoryState> emit) {
    List<Memory> filtered = _allMemories.where((memory) {
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        if (!memory.content.toLowerCase().contains(event.searchQuery!.toLowerCase())) return false;
      }
      if (event.emoji != null && event.emoji!.isNotEmpty) {
        if (memory.emoji != event.emoji) return false;
      }
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
      if (event.startDate != null || event.endDate != null) {
        final DateTime? memDate = _repository.parseDate(memory.date);
        if (memDate != null) {
          if (event.startDate != null) {
            final start = DateTime(event.startDate!.year, event.startDate!.month, event.startDate!.day);
            if (memDate.isBefore(start)) return false;
          }
          if (event.endDate != null) {
            final end = DateTime(event.endDate!.year, event.endDate!.month, event.endDate!.day, 23, 59, 59);
            if (memDate.isAfter(end)) return false;
          }
        }
      }
      return true;
    }).toList();
    emit(MemoryLoaded(filtered));
  }
}