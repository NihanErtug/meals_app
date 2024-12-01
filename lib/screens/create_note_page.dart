import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateNotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _notesController = TextEditingController();

    Future<void> _saveNote() async {
      if (_notesController.text.isEmpty) return;

      try {
        await FirebaseFirestore.instance.collection('notes').add({
          'content': _notesController.text,
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
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Not İçeriği",
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
