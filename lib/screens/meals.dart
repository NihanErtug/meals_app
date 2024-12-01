import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/meal_provider.dart';
import 'package:meals_app/widgets/meal_card.dart';
import '../widgets/search_bar.dart';

class Meals extends StatefulWidget {
  const Meals({super.key, required this.category});
  final Category category;

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  late List<Meal> mealList = [];
  bool _showNotFoundMessage = false;

  bool _isLoading = true;

  final MealProvider _mealProvider = MealProvider();

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals([String searchTerm = '']) async {
    setState(() {
      _isLoading = true;
    });

    try {
      mealList = await _mealProvider.fetchMealsByCategory(
          widget.category.id, searchTerm);
      setState(() {
        _showNotFoundMessage = mealList.isEmpty && searchTerm.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showNotFoundMessage = true;
      });
    }
  }

  void _updateMealList(String searchTerm) {
    _fetchMeals(searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 70.0,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 60, bottom: 16),
              title: Text(
                "${widget.category.name} Listesi",
                style: GoogleFonts.protestRevolution(
                    textStyle: TextStyle(color: widget.category.color)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: MySearchBar(
                onChanged: _updateMealList,
              ),
            ),
          ),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : _showNotFoundMessage
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text("Aradığınız yemek bulunamadı."),
                      ),
                    )
                  : mealList.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text("Bu kategoriye ait yemek bulunamadı."),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => MealCard(
                              meal: mealList[index],
                            ),
                            childCount: mealList.length,
                          ),
                        ),
        ],
      ),
    );
  }
}
