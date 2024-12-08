/* import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateNotePage extends StatelessWidget {
  const CreateNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController notesController = TextEditingController();

    Future<void> saveNote() async {
      if (notesController.text.isEmpty) return;

      try {
        await FirebaseFirestore.instance.collection('notes').add({
          'content': notesController.text,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        });
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hata: Not kaydedilemedi')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Not Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: "Not İçeriği",
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveNote,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
 */