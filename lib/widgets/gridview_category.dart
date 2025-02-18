import 'package:admin/models/category_model.dart';
import 'package:admin/widgets/category_card.dart';
import 'package:flutter/material.dart';

class GridviewCategory extends StatelessWidget {
  GridviewCategory({super.key});

  final List<Category> _allCategories = [
    Category(name: "Cơm", icon: Icons.rice_bowl),
    Category(name: "Phở", icon: Icons.restaurant_menu),
    Category(name: "Mì", icon: Icons.ramen_dining),
    Category(name: "Bún", icon: Icons.ramen_dining),
    Category(name: "Cháo", icon: Icons.ramen_dining),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _allCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // mainAxisSpacing: 8.0,
          // crossAxisSpacing: 8.0,
          childAspectRatio: 1.2),
      itemBuilder: (context, index) {
        final category = _allCategories[index];
        return CategoryCard(category: category);
      },
    );
  }
}
