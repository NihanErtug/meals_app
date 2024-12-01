import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:meals_app/models/meal.dart';

class EditRecipePage extends StatefulWidget {
  final Meal meal;
  const EditRecipePage({super.key, required this.meal});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController _nameController;
  late TextEditingController _ingredientsController;
  late TextEditingController _recipeController;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meal.name);
    _ingredientsController =
        TextEditingController(text: widget.meal.ingredients.join(', '));
    _recipeController = TextEditingController(text: widget.meal.recipe);
    _imageUrl = widget.meal.imageUrl!;
  }

  Future<void> _updateMeal() async {
    final updatedMeal = Meal(
      id: widget.meal.id,
      categoryId: widget.meal.categoryId,
      name: _nameController.text,
      imageUrl: _imageUrl,
      ingredients: _ingredientsController.text.split(', '),
      rating: widget.meal.rating,
      recipe: _recipeController.text,
      note: widget.meal.note,
    );

    try {
      await FirebaseFirestore.instance
          .collection('meals')
          .doc(widget.meal.id)
          .update(updatedMeal.toFirestore());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarif güncellendi')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata: Tarif güncellenemedi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarifi Düzenle"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Yemek Adı'),
                  onChanged: (value) {
                    setState(() {});
                  }),
              TextField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                    labelText: 'Malzemeler (virgülle ayırın)'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              TextField(
                controller: _recipeController,
                decoration: const InputDecoration(labelText: 'Tarif'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateMeal,
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
