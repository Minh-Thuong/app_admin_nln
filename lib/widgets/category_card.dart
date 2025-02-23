import 'package:admin/models/category_model.dart';
import 'package:admin/screen/category/category_detail_screen.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   // return CategoryDetailScreen();
        // }));
      },
      child: SizedBox(
        width: double
            .infinity, // Đảm bảo item sử dụng hết chiều rộng trong GridView
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              // child: Icon(
              //   // category.icon,
              //   // color: Colors.white,
              // ),
            ),
            const SizedBox(height: 8),
            // Text(category.name),
            // hiển thị check mark nếu đã chọn
          ],
        ),
      ),
    );
  }
}
