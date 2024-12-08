import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:meals_app/models/meal.dart';

import 'package:meals_app/screens/meal_detail.dart';

class MealNotesPage extends StatelessWidget {
  const MealNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tüm Notlar',
            ),
            /* IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNotePage()));
                },
                icon: const Icon(Icons.add_box)), */
          ],
        ),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final noteData = notes[index].data();
              final noteId = notes[index].id;
              final mealId = noteData['mealId'] as String;
              final content = noteData['content'] as String;

              return FutureBuilder<Meal?>(
                future: _fetchMeal(mealId),
                builder: (context, mealSnapshot) {
                  if (!mealSnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final meal = mealSnapshot.data!;
                  return ListTile(
                    title: Text(content),
                    subtitle: Text(
                      "Yemek Adı: ${meal.name}",
                      style: TextStyle(color: Colors.teal),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MealDetail(meal: meal)));
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final newContent =
                                await _editNoteDialog(context, content);

                            if (newContent != null && newContent.isNotEmpty) {
                              await _updateNote(context, noteId, newContent);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            bool? confirmDelete =
                                await _showDeleteConfirmationDialog(context);
                            if (confirmDelete == true) {
                              await _deleteNote(context, noteId);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Meal?> _fetchMeal(String mealId) async {
    try {
      final mealDoc = await FirebaseFirestore.instance
          .collection('meals')
          .doc(mealId)
          .get();
      if (mealDoc.exists) {
        return Meal.fromFirestore(mealDoc);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _updateNote(
      BuildContext context, String noteId, String newContent) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(noteId).update({
        'content': newContent,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      _showErrorSnackBar(context, "Not güncellenemedi");
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Notu Sil"),
              content:
                  const Text("Bu notu silmek istediğinizden emin misiniz?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Hayır")),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Evet")),
              ],
            ));
  }

  Future<void> _deleteNote(BuildContext context, String noteId) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hata: Not silinemedi")),
      );
    }
  }

  Future<void> _showErrorSnackBar(BuildContext context, String message) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String?> _editNoteDialog(BuildContext context, String content) {
    final TextEditingController editController =
        TextEditingController(text: content);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Notu Düzenle"),
        content: TextField(
          controller: editController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(editController.text);
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }
}
