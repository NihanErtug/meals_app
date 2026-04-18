import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/notes/notes_provider.dart';
import 'package:meals_app/providers/favorites_notifier.dart';
import 'package:meals_app/recipe/edit_recipe_page.dart';

import '../../notes/meal_notes_page.dart';

class MealDetail extends ConsumerStatefulWidget {
  const MealDetail({super.key, required this.meal});
  final Meal meal;

  @override
  _MealDetailState createState() => _MealDetailState();
}

class _MealDetailState extends ConsumerState<MealDetail> {
  List<String> _notes = [];
  late TextEditingController _noteController;
  late final NotesProvider _notesProvider;

  late Meal _meal;

  @override
  void initState() {
    super.initState();
    _meal = widget.meal;
    _noteController = TextEditingController();
    _notesProvider = NotesProvider();
    _loadNotesOnce();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadNotesOnce() async {
    try {
      final notesList = await _notesProvider.fetchNotes(_meal.id).first;
      if (!mounted) return;
      setState(() {
        _notes = notesList;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Notlar yüklenemedi.")));
    }
  }

  Future<void> _refreshMeal() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('meals')
          .doc(_meal.id)
          .get();

      if (!mounted || !doc.exists) return;

      setState(() {
        _meal = Meal.fromFirestore(doc);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Yemek bilgisi yenilenemedi.")));
    }
  }

  Future<void> _saveNote() async {
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty) return;

    try {
      await _notesProvider.addNote(_meal.id, noteText);

      if (!mounted) return;
      setState(() {
        _notes.insert(0, noteText);
      });

      _noteController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notunuz kaydedildi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata: Not kaydedilemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteMealsProvider);
    final isFavorite = favorites.any((meal) => meal.id == _meal.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(_meal.name,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway')),
        actions: [
          if (_meal.rating != 0.0)
            Text(
              "${_meal.rating}",
              style: TextStyle(fontSize: 16),
            ),
          IconButton(
              onPressed: () async {
                final updated = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                        builder: (context) =>
                            EditRecipePage(mealId: _meal.id)));

                if (updated == true) {
                  await _refreshMeal();
                }
              },
              icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () {
              ref.read(favoriteMealsProvider.notifier).toggleFavorite(_meal);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _meal.imageUrl!.isNotEmpty
                        ? _meal.imageUrl!
                        : 'assets/default_image.jpg',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/default_image.jpg');
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    " Malzemeler ",
                    style: TextStyle(
                        fontSize: 21,
                        fontFamily: 'Raleway',
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 9),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _meal.ingredients.map((e) {
                    return Text(
                      " -  $e",
                      style: const TextStyle(fontSize: 17),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Divider(),
                Center(
                  child: Text(" Yapılışı ",
                      style: TextStyle(
                          fontSize: 21,
                          fontFamily: 'Raleway',
                          decoration: TextDecoration.underline)),
                ),
                const SizedBox(height: 9),
                Text(
                  _meal.recipe,
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(48, 117, 117, 117),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Not Ekle:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _noteController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: "Notunuzu buraya girin",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _saveNote,
                            child: const Text("Kaydet"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Notlar:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                if (_notes.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _notes.map((content) {
                      return GestureDetector(
                        onTap: () async {
                          final changed =
                              await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (context) => const MealNotesPage(),
                            ),
                          );
                          if (changed == true) {
                            await _loadNotesOnce();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text("- $content"),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
