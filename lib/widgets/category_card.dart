import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals_app/models/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onCategoryClick,
  });
  final Category category;
  final void Function() onCategoryClick;
  // dönüş tipi-burada void- yazılıyorsa () konmalı.

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: onCategoryClick;  -> sadece dışarıyı haberdar eder.
      onTap: () {
        onCategoryClick(); // -> dışarıyı haberdar et, varsa diğer işlemleri yürüt.
      },
      child: Container(
        decoration: BoxDecoration(
            //color: const Color.fromARGB(211, 213, 0, 0),
            // geçişli renk vermek için
            gradient: LinearGradient(colors: [
              //Color.fromARGB(255, 226, 86, 76),
              //Color.fromARGB(211, 213, 0, 0)
              //Colors.red.withOpacity(0.9),
              //Colors.red.withOpacity(0.5)
              category.color.withOpacity(0.9),
              category.color.withOpacity(0.3)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(26.0),
        child: Center(
          child: Text(
            category.name,
            style: GoogleFonts.caveat(textStyle: TextStyle(fontSize: 22)),
          ),
        ),
      ),
    );
  }
}
