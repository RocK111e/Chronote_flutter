// lib/data/memory_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/memory.dart';
import '../utils/date_helper.dart';

class MemoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<List<Memory>> getMemories() async {
    if (_userId.isEmpty) return [];

    try {
      final querySnapshot = await _firestore
          .collection('memories')
          .where('userId', isEqualTo: _userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Memory.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching memories: $e');
    }
  }

  Future<void> addMemory(Memory memory) async {
    if (_userId.isEmpty) throw Exception('User not logged in');
    
    final memoryWithUser = Memory(
      userId: _userId, 
      date: memory.date,
      content: memory.content,
      tags: memory.tags,
      emoji: memory.emoji,
      imageUrl: memory.imageUrl,
    );

    await _firestore.collection('memories').add(memoryWithUser.toFirestore());
  }

  Future<void> updateMemory(Memory memory) async {
    if (memory.id == null) throw Exception('Memory ID is null');
    await _firestore
        .collection('memories')
        .doc(memory.id)
        .update(memory.toFirestore());
  }

  // UPDATED: Now takes the full Memory object to access the imageUrl
  Future<void> deleteMemory(Memory memory) async {
    if (memory.id == null) return;

    // 1. Try to delete the image from Storage if it exists
    if (memory.imageUrl != null && memory.imageUrl!.isNotEmpty) {
      try {
        // refFromURL creates a reference directly from the download link
        await _storage.refFromURL(memory.imageUrl!).delete();
      } catch (e) {
        // We log it but don't stop the process. 
        // Even if image delete fails (e.g. file already gone), we still want to delete the note.
        print("⚠️ Warning: Could not delete image file: $e");
      }
    }

    // 2. Delete the document from Firestore
    await _firestore.collection('memories').doc(memory.id).delete();
  }

  Future<String?> uploadImage(XFile file) async {
    if (_userId.isEmpty) return null;

    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = _storage
          .ref()
          .child('users/$_userId/memories/$fileName');

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await storageRef.putData(await file.readAsBytes(), metadata);
      
      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  DateTime? parseDate(String dateString) {
    return DateHelper.parse(dateString);
  }
}