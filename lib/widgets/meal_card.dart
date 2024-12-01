import 'package:flutter/material.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_detail.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetail(meal: meal),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                _buildParallaxBackground(),
                _buildGradient(),
                _buildTitle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.6, 0.95],
        )),
      ),
    );
  }

  Widget _buildParallaxBackground() {
    return meal.imageUrl != null && meal.imageUrl!.isNotEmpty
        ? Image.network(
            meal.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/default_image.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          )
        : Image.asset(
            "assets/default_image.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
          );
  }

  Widget _buildTitle() {
    return Positioned(
        left: 20,
        bottom: 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ));
  }
}
