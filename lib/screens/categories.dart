import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/data/category_data.dart';

import 'package:meals_app/models/category.dart';
import 'package:meals_app/providers/theme_notifier.dart';

import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_card.dart';

class Categories extends ConsumerStatefulWidget {
  final NotchBottomBarController? controller;
  const Categories({super.key, this.controller});

  @override
  ConsumerState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  void _changeScreen(Category c, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Meals(category: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const List<Category> categoryList = categories;

    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kategoriler",
        ),
        actions: [
          IconButton(
              icon: Icon(
                ref.watch(themeProvider) == ThemeMode.light
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
              ),
              onPressed: () {
                final themeNotifier = ref.read(themeProvider.notifier);
                themeNotifier.toggleTheme(themeMode != ThemeMode.dark);
              }),
        ],
      ),
      body: SafeArea(
        child: GridView(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 25,
              childAspectRatio: 2 / 1.5),
          children: categoryList
              .map((e) => CategoryCard(
                    category: e,
                    onCategoryClick: () {
                      _changeScreen(e, context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
