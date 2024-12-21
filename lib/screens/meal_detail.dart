import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String? _note;
  List<String> _notes = [];
  late TextEditingController _noteController;
  late final NotesProvider _notesProvider;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: _note);
    _notesProvider = NotesProvider();
    _fetchNotes();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _fetchNotes() {
    _notesProvider.fetchNotes(widget.meal.id).listen((notesList) {
      if (mounted) {
        setState(() {
          _notes = notesList;
        });
      }
    });
  }

  Future<void> _saveNote() async {
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty) return;

    if (_note == null || _note!.trim().isEmpty) return;

    try {
      await _notesProvider.addNote(widget.meal.id, _note!.trim());

      _noteController.clear();
      _note = null;

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
    final isFavorite = favorites.any((meal) => meal.id == widget.meal.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.name,
            style: GoogleFonts.raleway(
                textStyle:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.w500))),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditRecipePage(
                          mealId: widget.meal.id,
                        )));
                setState(() {
                  _fetchNotes();
                });
              },
              icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () {
              ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleFavorite(widget.meal);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
          /* IconButton(
            onPressed: () {
              // paylaşım işlemi buraya gelecek
            },
            icon: const Icon(Icons.share),
          ), */
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.meal.imageUrl!.isNotEmpty
                      ? widget.meal.imageUrl!
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
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          fontSize: 21, decoration: TextDecoration.underline)),
                ),
              ),
              const SizedBox(height: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.meal.ingredients.map((e) {
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
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 21,
                            decoration: TextDecoration.underline))),
              ),
              const SizedBox(height: 9),
              Text(
                widget.meal.recipe,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: "Notunuzu buraya girin",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _note = value;
                        });
                      },
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
              // Kaydedilen notlar listesi
              if (_notes.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _notes.map((content) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MealNotesPage(),
                          ),
                        );
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
    );
  }
}
