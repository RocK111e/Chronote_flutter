import '../../models/memory.dart';

abstract class MemoryState {}

class MemoryLoading extends MemoryState {}

class MemoryLoaded extends MemoryState {
  final List<Memory> memories;

  MemoryLoaded(this.memories);
}

class MemoryError extends MemoryState {
  final String message;

  MemoryError(this.message);
}