import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/data/category_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _recipeController = TextEditingController();
  final _ingredientController = TextEditingController();

  final List<String> _ingredients = [];
  double _rating = 0.0;
  Category? _selectedCategory;
  String? _imageUrl = '';

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text);
        _ingredientController.clear();
      });
    }
  }

  Future<void> _saveRecepie() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final newMeal = Meal(
          id: '',
          categoryId: _selectedCategory!.id,
          name: _nameController.text,
          imageUrl: '',
          ingredients: _ingredients,
          rating: _rating,
          recipe: _recipeController.text);

      await FirebaseFirestore.instance
          .collection('meals')
          .add(newMeal.toFirestore());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tarif başarıyla kaydedildi.")),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarif Ekle"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      hint: const Text("Kategori Seçin"),
                      items: categories.map((Category category) {
                        return DropdownMenuItem<Category>(
                            value: category, child: Text(category.name));
                      }).toList(),
                      onChanged: (Category? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Kategori seçmelisiniz' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: "Tarif Adı"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Tarif adı boş olamaz.";
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Resim URL'),
                        onSaved: (value) => _imageUrl = value!),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: _ingredientController,
                          decoration:
                              const InputDecoration(labelText: "Malzeme Ekle"),
                        )),
                        IconButton(
                            onPressed: _addIngredient,
                            icon: const Icon(Icons.add)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _ingredients.map((ingredient) {
                        return Chip(
                          label: Text(ingredient),
                          onDeleted: () {
                            setState(() {
                              _ingredients.remove(ingredient);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _recipeController,
                        decoration: const InputDecoration(labelText: 'Tarif'),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Tarif boş olamaz.";
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    const Text(
                      "Puan",
                      style: TextStyle(fontSize: 16),
                    ),
                    Slider(
                      value: _rating,
                      onChanged: (newRating) {
                        setState(() {
                          _rating = newRating;
                        });
                      },
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _rating.toString(),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                          onPressed: _saveRecepie,
                          child: const Text("Tarifi Kaydet")),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
