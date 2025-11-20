abstract class MemoryEvent {}

class LoadMemories extends MemoryEvent {}

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