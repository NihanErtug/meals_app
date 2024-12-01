import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]) {
    _watchFavorites();
  }

  final CollectionReference _favoritesColleciton =
      FirebaseFirestore.instance.collection('favorites');

  StreamSubscription<QuerySnapshot<Object?>>? _favoritesSubscription;

  void _watchFavorites() {
    _favoritesSubscription =
        _favoritesColleciton.snapshots().listen((snapshot) {
      state = snapshot.docs.map((doc) {
        return Meal.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  Future<void> toggleFavorite(Meal meal) async {
    final isFavorite = state.any((favMeal) => favMeal.id == meal.id);

    if (isFavorite) {
      await _favoritesColleciton.doc(meal.id).delete();
    } else {
      await _favoritesColleciton.doc(meal.id).set(meal.toFirestore());
    }
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
