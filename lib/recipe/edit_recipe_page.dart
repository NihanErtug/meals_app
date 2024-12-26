import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/meal_provider.dart';
import 'package:meals_app/screens/homepage.dart';
import 'package:meals_app/screens/meals.dart';

class EditRecipePage extends StatefulWidget {
  final String mealId;

  const EditRecipePage({super.key, required this.mealId});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController _nameController;
  late TextEditingController _ingredientsController;
  late TextEditingController _recipeController;
  late TextEditingController _ratingController;
  late TextEditingController _imageUrlController;

  //late Meal _meal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ingredientsController = TextEditingController();
    _recipeController = TextEditingController();
    _ratingController = TextEditingController();
    _imageUrlController = TextEditingController();

    // dinleyiciyi başlatma
    //_fetchMealData();
  }

/*
  // veriyi çekme
  void _fetchMealData() {
    FirebaseFirestore.instance
        .collection('meals')
        .doc(widget.mealId)
        .snapshots() // veritabanındaki değişiklikleri anında dinlemek için
        .listen((mealSnapshot) {
      if (mealSnapshot.exists) {
        _meal = Meal.fromFirestore(mealSnapshot);

        // değişiklikler TextField lara yansıtılıyor
        _nameController.text = _meal.name;
        _ingredientsController.text = _meal.ingredients.join(', ');
        _recipeController.text = _meal.recipe;
        _ratingController.text = _meal.rating?.toString() ?? '';
        _imageUrlController.text = _meal.imageUrl ?? '';
        setState(() {}); // ekran güncelleniyor
      }
    });
  }
*/

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('meals')
          .doc(widget.mealId)
          .update({
        'name': _nameController.text,
        'ingredients': _ingredientsController.text
            .split(',')
            .map((ingredient) => ingredient.trim())
            .toList(),
        'rating': double.tryParse(_ratingController.text) ?? 0.0,
        'recipe': _recipeController.text,
        'imageUrl': _imageUrlController.text,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Tarif güncellendi')));

      Navigator.pop(context);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hata: Tarif güncellenemedi')));
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
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('meals')
            .doc(widget.mealId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Yemek bulunamadı"));
          }
          Meal meal = Meal.fromFirestore(snapshot.data!);

          _nameController.text = meal.name;
          _ingredientsController.text = meal.ingredients.join(', ');
          _recipeController.text = meal.recipe;
          _ratingController.text = meal.rating?.toString() ?? '';
          _imageUrlController.text = meal.imageUrl ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Yemek Adı'),
                  ),
                  TextField(
                    controller: _ingredientsController,
                    decoration: const InputDecoration(
                        labelText: 'Malzemeler (virgülle ayırın)'),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  TextField(
                    controller: _recipeController,
                    decoration: const InputDecoration(labelText: 'Tarif'),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(labelText: 'Resim URL'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _ratingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Puan'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text('Kaydet'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () async {
                            bool? confirmDelete =
                                await _showDeleteConfirmation(context);
                            if (confirmDelete == true) {
                              await _deleteRecipe(context, widget.mealId);
                            }
                          },
                          child: Text("Tarifi Sil")),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
