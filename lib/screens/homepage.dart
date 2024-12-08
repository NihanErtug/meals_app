import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/notes/meal_notes_page.dart';

import 'package:meals_app/screens/add_recipe_page.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/favorites.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  BottomBarItem buildBottomBarItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    return BottomBarItem(
        inActiveItem: Icon(
          inactiveIcon,
          color: Colors.cyan[800],
        ),
        activeItem: Icon(
          activeIcon,
          color: Colors.cyan[600],
        ),
        itemLabel: label);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Categories(
        controller: (_controller),
      ),
      const Favorites(),
      const MealNotesPage(),
      const AddRecipePage(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Theme.of(context).colorScheme.onPrimary,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: const Color.fromARGB(192, 53, 49, 49),
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: true,
              durationInMilliSeconds: 300,
              itemLabelStyle:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              elevation: 1,
              bottomBarItems: [
                buildBottomBarItem(
                    activeIcon: Icons.home_filled,
                    inactiveIcon: Icons.home_filled,
                    label: "Kategoriler"),
                buildBottomBarItem(
                    activeIcon: Icons.favorite,
                    inactiveIcon: Icons.favorite,
                    label: "Favoriler"),
                buildBottomBarItem(
                    activeIcon: Icons.note,
                    inactiveIcon: Icons.note,
                    label: "Notlar"),
                buildBottomBarItem(
                    activeIcon: Icons.add_comment_rounded,
                    inactiveIcon: Icons.add_comment_rounded,
                    label: "Tarif Ekle"),
              ],
              onTap: (index) {
                //log('seçili dizin $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}
