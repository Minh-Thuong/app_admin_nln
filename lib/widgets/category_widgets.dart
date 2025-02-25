import 'package:admin/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildCategoryGrid(List<Category> categories, Category? selected, Function(Category) onToggle) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 0.8,
    ),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      final cat = categories[index];
      final isSelected = selected?.id == cat.id;// true or false
      return InkWell(
        onTap: () => onToggle(cat),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
                      image: cat.profileImage != null
                          ? DecorationImage(image: NetworkImage(cat.profileImage!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: cat.profileImage == null ? const Center(child: Icon(Icons.image_not_supported)) : null,
                  ),
                  if (isSelected)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cat.name ?? 'Tên không có',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildBottomButtons(BuildContext context, Category? selected) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop<Category>(context, selected),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Xác nhận"),
          ),
        ),
      ],
    ),
  );
}