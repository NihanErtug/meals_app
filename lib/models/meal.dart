import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String id;
  String categoryId;
  String name;
  String? imageUrl;
  List<String> ingredients;
  double? rating;
  String recipe;
  String? note;

  Meal({
    required this.id,
    required this.categoryId,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    this.rating,
    required this.recipe,
    this.note,
  });

  static Meal fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Missing data for mealId: ${doc.id}');
    }

    return Meal(
      id: doc.id,
      categoryId: data['categoryId'] as String,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] as String,
      ingredients: List<String>.from(data['ingredients'] as List<dynamic>),
      rating: (data['rating'] as num).toDouble(),
      recipe: data['recipe'] as String,
      note: data['note'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'name': name,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'rating': rating,
      'recipe': recipe,
      'note': note,
    };
  }
}
