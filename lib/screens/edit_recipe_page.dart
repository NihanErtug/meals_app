import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/homepage.dart';

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
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meal.name);
    _ingredientsController =
        TextEditingController(text: widget.meal.ingredients.join(', '));
    _recipeController = TextEditingController(text: widget.meal.recipe);
    _imageUrlController = TextEditingController(text: widget.meal.imageUrl!);
  }

  Future<void> _updateMeal() async {
    final updatedMeal = Meal(
      id: widget.meal.id,
      categoryId: widget.meal.categoryId,
      name: _nameController.text,
      imageUrl: _imageUrlController.text,
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarif güncellendi')),
        );
      });

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata: Tarif güncellenemedi')),
      );
    }
  }

  Future<void> _deleteRecipe(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance.collection('meals').doc(id).delete();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Tarif silindi")));

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Hata: Tarif silinemedi")));
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tarifi Sil"),
              content: Text("Tarifi silmek istediğinizden emin misiniz?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Hayır")),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Evet")),
              ],
            ));
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
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Resim URL'),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _updateMeal,
                    child: const Text('Kaydet'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () async {
                        bool? confirmDelete =
                            await _showDeleteConfirmation(context);
                        if (confirmDelete == true) {
                          await _deleteRecipe(context, widget.meal.id);
                        }
                      },
                      child: Text("Tarifi Sil")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
