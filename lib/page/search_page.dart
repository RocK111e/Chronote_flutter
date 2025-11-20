// lib/page/search_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../bloc/memory/memory_state.dart';
import '../models/memory.dart';
import '../widgets/tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _showFilters = false;
  
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  late MemoryBloc _memoryBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _memoryBloc = context.read<MemoryBloc>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tagController.dispose();
    _emojiController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();

    _memoryBloc.add(LoadMemories());
    
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.trim();
    final tags = _tagController.text.isNotEmpty
        ? _tagController.text.split(',').map((e) => e.trim()).toList()
        : null;
    final emoji = _emojiController.text.trim();

    context.read<MemoryBloc>().add(FilterMemories(
      searchQuery: query,
      tags: tags,
      emoji: emoji.isNotEmpty ? emoji : null,
      startDate: _startDate,
      endDate: _endDate,
    ));
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (context) {
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            setState(() {
              _emojiController.text = emoji.emoji;
            });
            _applyFilters();
            Navigator.pop(context);
          },
          config: const Config(
            height: 300,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              backgroundColor: Color(0xFF1E1E1E),
              columns: 7,
              emojiSizeMax: 28,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: Text('No Recents', style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center),
            ),
            categoryViewConfig: CategoryViewConfig(
              backgroundColor: Color(0xFF1E1E1E),
              indicatorColor: Colors.blue,
              iconColorSelected: Colors.blue,
              iconColor: Colors.grey,
              tabIndicatorAnimDuration: kTabScrollDuration,
              dividerColor: Colors.transparent,
            ),
            bottomActionBarConfig: BottomActionBarConfig(enabled: false),
            searchViewConfig: SearchViewConfig(
               backgroundColor: Color(0xFF1E1E1E),
               buttonIconColor: Colors.grey, 
            )
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart 
        ? (_startDate ?? DateTime.now()) 
        : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = DateFormat('MM/dd/yyyy').format(picked);
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('MM/dd/yyyy').format(picked);
        }
      });
      _applyFilters();
    }
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  void _clearFilters() {
    _searchController.clear();
    _tagController.clear();
    _emojiController.clear();
    _startDateController.clear();
    _endDateController.clear();
    
    setState(() {
      _startDate = null;
      _endDate = null;
    });

    context.read<MemoryBloc>().add(LoadMemories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryBloc, MemoryState>(
      builder: (context, state) {
        List<Memory> results = [];
        if (state is MemoryLoaded) {
          results = state.memories;
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSearchCard(),
            const SizedBox(height: 32),
            _buildResultsHeader(results.length),
            const SizedBox(height: 16),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "No results found", 
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ...results.map((memory) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: MemoryTile(memory: memory),
              )),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Find your memories',
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

  Widget _buildSearchCard() {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchTextField(),
            const SizedBox(height: 16),
            _buildFilterToggleButton(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SizeTransition(sizeFactor: animation, child: child);
              },
              child: _showFilters ? _buildFilterSection() : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration('Search by text...', prefixIcon: Icons.search),
      onChanged: (_) => _applyFilters(),
    );
  }

  Widget _buildFilterToggleButton() {
    return TextButton.icon(
      onPressed: _toggleFilters,
      icon: Icon(Icons.filter_list, color: Colors.grey[400], size: 20),
      label: Text(
        _showFilters ? 'Hide Filters' : 'Show Filters',
        style: TextStyle(color: Colors.grey[400]),
      ),
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _buildFilterSection() {
    final hasEmoji = _emojiController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text('Filter by Tags', style: TextStyle(color: Colors.grey[400])),
        const SizedBox(height: 8),
        TextField(
          controller: _tagController,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Enter tags (comma separated)...'),
          onChanged: (_) => _applyFilters(),
        ),
        
        const SizedBox(height: 16),
        Text('Filter by Emoji', style: TextStyle(color: Colors.grey[400])),
        const SizedBox(height: 8),
        
        TextField(
          controller: _emojiController,
          readOnly: true,
          onTap: _showEmojiPicker,
          style: TextStyle(
            color: Colors.white, 
            fontFamily: hasEmoji ? 'NotoColorEmoji' : null, 
            fontSize: hasEmoji ? 24 : 16, 
          ),
          decoration: _inputDecoration(
            'Select an emoji...', 
            prefixIcon: Icons.emoji_emotions_outlined,
            suffixIcon: hasEmoji ? Icons.close : null,
          ).copyWith(
            suffixIcon: hasEmoji 
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[400], size: 20),
                  onPressed: () {
                    setState(() {
                      _emojiController.clear();
                    });
                    _applyFilters();
                  },
                )
              : null,
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start Date', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _startDateController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('mm/dd/yyyy', suffixIcon: Icons.calendar_today_outlined),
                    onTap: () => _selectDate(context, true),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('End Date', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _endDateController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('mm/dd/yyyy', suffixIcon: Icons.calendar_today_outlined),
                    onTap: () => _selectDate(context, false),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        TextButton(
          onPressed: _clearFilters,
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: Colors.grey.withOpacity(0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          child: Text('Clear All Filters', style: TextStyle(color: Colors.grey[400])),
        ),
      ],
    );
  }

  Widget _buildResultsHeader(int count) {
    return Text(
      '$count result${count != 1 ? 's' : ''}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, {IconData? prefixIcon, IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[400], size: 20) : null,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey[400], size: 20) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}