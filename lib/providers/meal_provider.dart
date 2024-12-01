import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meals_app/models/meal.dart';

class MealProvider {
  final CollectionReference _mealCollection =
      FirebaseFirestore.instance.collection('meals');

  // belirli bir kategoriye ait yemekleri getir

  Future<List<Meal>> fetchMealsByCategory(String categoryId,
      [String searchTerm = '']) async {
    try {
      QuerySnapshot snapshot = await _mealCollection
          .where('categoryId', isEqualTo: categoryId)
          .get();

      List<Meal> meals = snapshot.docs.map((doc) {
        return Meal(
          id: doc.id,
          categoryId: doc['categoryId'],
          name: doc['name'],
          imageUrl: doc['imageUrl'],
          ingredients: List<String>.from(doc['ingredients']),
          rating: (doc['rating'] as num).toDouble(),
          recipe: doc['recipe'],
        );
      }).toList();

      return meals.where((meal) {
        return meal.name.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception("Yemekler alınırken bir hata oluştu: $e");
    }
  }
}
