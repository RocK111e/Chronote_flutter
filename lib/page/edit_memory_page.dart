// lib/page/edit_memory_page.dart

import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart'; 
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../models/memory.dart';

class EditMemoryPage extends StatefulWidget {
  final Memory? memory;

  const EditMemoryPage({super.key, this.memory});

  @override
  State<EditMemoryPage> createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  final _contentController = TextEditingController();
  final _tagInputController = TextEditingController();
  final _dateController = TextEditingController();
  final _emojiController = TextEditingController();

  List<String> _tags = [];
  DateTime _selectedDate = DateTime.now();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedEmoji; 
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.memory != null) {
      _contentController.text = widget.memory!.content;
      _tags = List.from(widget.memory!.tags);
      _selectedDate = DateTime.tryParse(widget.memory!.date) ?? DateTime.now();
      _selectedEmoji = widget.memory!.emoji;
    }
    _updateDateText();
    _updateEmojiText();
  }

  void _updateDateText() {
    // UPDATED: Matches the requested format (Mon, Oct 25, 2025 14:30)
    _dateController.text = DateFormat('EEE, MMM d, yyyy HH:mm').format(_selectedDate);
  }

  void _updateEmojiText() {
    if (_selectedEmoji != null) {
      _emojiController.text = _selectedEmoji!;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagInputController.dispose();
    _dateController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (context) {
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            setState(() {
              _selectedEmoji = emoji.emoji;
              _updateEmojiText();
            });
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

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
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

    if (pickedDate == null) return;
    if (!mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          // UPDATED: Force 24-hour format in the picker
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _updateDateText();
    });
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = picked;
      });
    }
  }

  void _addTag() {
    final text = _tagInputController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        _tagInputController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveMemory() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something!')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final memoryData = Memory(
      id: widget.memory?.id,
      userId: widget.memory?.userId ?? '',
      date: _selectedDate.toIso8601String(),
      content: _contentController.text.trim(),
      tags: _tags,
      emoji: _selectedEmoji,
      imageUrl: widget.memory?.imageUrl,
    );

    if (widget.memory == null) {
      context.read<MemoryBloc>().add(AddMemory(memoryData, imageFile: _imageFile));
    } else {
      context.read<MemoryBloc>().add(UpdateMemory(memoryData, newImageFile: _imageFile));
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
         Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leadingWidth: 0,
        titleSpacing: 16,
        title: Text(
          widget.memory == null ? 'New Entry' : 'Edit Entry',
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveMemory,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B73B9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Date & Time'),
            const SizedBox(height: 8),
            _buildDateTimePicker(),
            const SizedBox(height: 24),

            _buildLabel("Mood"),
            const SizedBox(height: 8),
            _buildEmojiSelector(),
            const SizedBox(height: 24),
            
            _buildLabel("What's on your mind?"),
            const SizedBox(height: 8),
            _buildContentField(),
            const SizedBox(height: 24),
            
            _buildLabel('Tags'),
            const SizedBox(height: 8),
            _buildTagInput(),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildTagChips(),
            ],
            const SizedBox(height: 24),
            
            _buildLabel('Media files'),
            const SizedBox(height: 8),
            _buildMediaButton(),
            const SizedBox(height: 16),
            _buildImagePreview(),
          ],
        ),
      ),
    );
  }

  // ... (Helper methods remain the same, just keeping the file complete)
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFB3B3B3),
        fontSize: 16,
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return TextField(
      controller: _dateController,
      readOnly: true,
      onTap: _pickDateTime,
      style: const TextStyle(color: Colors.grey),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        hintText: 'Date & Time',
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3B73B9)),
        ),
      ),
    );
  }

  Widget _buildEmojiSelector() {
    final hasEmoji = _selectedEmoji != null;
    return TextField(
      controller: _emojiController,
      readOnly: true,
      onTap: _showEmojiPicker,
      style: const TextStyle(
        color: Colors.white, 
        fontFamily: 'NotoColorEmoji',
        fontSize: 24,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        hintText: 'Select a mood...',
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        prefixIcon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
        suffixIcon: hasEmoji 
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _selectedEmoji = null;
                  _emojiController.clear();
                });
              },
            )
          : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: TextField(
        controller: _contentController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          hintText: 'Write your thoughts here...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTagInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _tagInputController,
            style: const TextStyle(color: Colors.grey),
            onSubmitted: (_) => _addTag(),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              hintText: 'Add a tag...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF333333)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF333333)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF3B73B9)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E50),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF3B73B9)),
          ),
          child: IconButton(
            icon: const Icon(Icons.local_offer_outlined, color: Color(0xFF3B73B9)),
            onPressed: _addTag,
          ),
        ),
      ],
    );
  }

  Widget _buildTagChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _tags.map((tag) {
        return Chip(
          label: Text(tag, style: const TextStyle(color: Color(0xFF64B5F6))),
          backgroundColor: const Color(0xFF1E2A38),
          deleteIcon: const Icon(Icons.close, size: 16, color: Color(0xFF64B5F6)),
          onDeleted: () => _removeTag(tag),
          side: const BorderSide(color: Color(0xFF3B73B9)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        );
      }).toList(),
    );
  }

  Widget _buildMediaButton() {
    return SizedBox(
      width: 200,
      child: OutlinedButton.icon(
        onPressed: _pickImage,
        icon: const Icon(Icons.image_outlined, color: Colors.grey),
        label: const Text('Attach Photo or Video', style: TextStyle(color: Colors.grey)),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          alignment: Alignment.centerLeft,
          side: const BorderSide(color: Color(0xFF333333)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: kIsWeb 
              ? Image.network(_imageFile!.path, height: 150, width: double.infinity, fit: BoxFit.cover)
              : Image.file(File(_imageFile!.path), height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _imageFile = null),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      );
    } else if (widget.memory?.imageUrl != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.memory!.imageUrl!, 
              height: 150, 
              width: double.infinity, 
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}