import 'package:cloud_firestore/cloud_firestore.dart';

class NotesProvider {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Stream<List<String>> fetchNotes(String mealId) {
    return _notesCollection
        .where('mealId', isEqualTo: mealId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['content'] as String).toList();
    });
  }

  Future<void> addNote(String mealId, String content) async {
    try {
      await _notesCollection.add({
        'mealId': mealId,
        'content': content,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _notesCollection.doc(noteId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
