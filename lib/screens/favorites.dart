import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favorites_notifier.dart';
import 'package:meals_app/screens/meal_detail.dart';

class Favorites extends ConsumerWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Meal> favorites = ref.watch(favoriteMealsProvider);

    final Map<String, String> categoryMap = {
      "1": "Çorbalar",
      "2": "Ara Sıcaklar",
      "3": "Mezeler",
      "4": "Ana Yemekler",
      "5": "Tatlılar",
      "6": "İçecekler"
    };

    final Map<String, List<Meal>> categorizedMeals = {};
    for (var meal in favorites) {
      final String categoryName =
          categoryMap[meal.categoryId] ?? "Bilinmeyen Kategori";
      categorizedMeals.putIfAbsent(categoryName, () => []).add(meal);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favori Yemekler",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: CustomScrollView(
            slivers: categorizedMeals.entries.map((entry) {
              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entry.key,
                      style: GoogleFonts.caveat(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(decoration: TextDecoration.underline)),
                    ),
                  ),
                  ...entry.value.map((meal) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MealDetail(meal: meal)));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          child: ClipOval(
                            child: Image.network(
                              meal.imageUrl!.isNotEmpty ? meal.imageUrl! : '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/default_image.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          meal.name,
                          style: const TextStyle(
                              fontSize: 18,
                              //color: Colors.black87,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                ]),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
