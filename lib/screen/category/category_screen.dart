import 'package:admin/models/category_model.dart';
import 'package:admin/screen/category/create_category_screen.dart';
import 'package:admin/widgets/gridview_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 3. Màn hình chọn danh mục (Hình 2)
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategoryScreen> {
  // Danh sách tất cả danh mục có thể chọn
  // Tuỳ bạn thêm bớt
  final List<Category> _allCategories = [
    Category(name: "Cơm", icon: Icons.rice_bowl),
    Category(name: "Phở", icon: Icons.restaurant_menu),
    Category(name: "Mì", icon: Icons.ramen_dining),
    Category(name: "Bún", icon: Icons.ramen_dining),
    Category(name: "Cháo", icon: Icons.ramen_dining),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh mục"),
      ),
      body: Stack(children: [
        Column(
          children: [
            // Text field tìm tên danh mục
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tìm tên danh mục",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Danh sách danh mục
            Expanded(
              child: GridviewCategory(),
            ),
          ],
        ),
        Positioned(
          bottom: 50.h,
          right: 25.w,
          child: FloatingActionButton(
            shape: CircleBorder(side: BorderSide(color: Colors.white)),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateCategoryScreen(),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
