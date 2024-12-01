import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:meals_app/data/category_data.dart';

import 'package:meals_app/models/category.dart';

import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_card.dart';

class Categories extends StatefulWidget {
  final NotchBottomBarController? controller;
  const Categories({super.key, this.controller});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kategoriler",
        ),
      ),
      body: GridView(
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
    );
  }
}
