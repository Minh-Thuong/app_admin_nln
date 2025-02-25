import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin/models/category_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Widget buildTextField({
  required String label,
  required TextEditingController controller,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    ],
  );
}

Widget buildPriceField(String label, TextEditingController controller) {
  return buildTextField(label: label, controller: controller, keyboardType: TextInputType.number);
}

Widget buildCategorySelection(Category? selectedCategory, VoidCallback onSelect) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Danh mục", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: selectedCategory == null
                ? const Text("Chưa chọn danh mục", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
                : Chip(
                    label: Text(selectedCategory.name ?? 'Unknown'),
                    avatar: const Icon(Icons.category_sharp, size: 16, color: Colors.lightBlueAccent),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => onSelect(),
                  ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onSelect,
            icon: const Icon(Icons.category),
            label: Text(selectedCategory == null ? "Chọn danh mục" : "Đổi danh mục"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
          ),
        ],
      ),
    ],
  );
}

Widget buildImagePreview(XFile image, VoidCallback onRemove) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(File(image.path), width: double.infinity, height: 200.h, fit: BoxFit.cover),
      ),
      Positioned(
        top: 0.h,
        right: 0.w,
        child: GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: const Center(child: Icon(Icons.close, color: Colors.white, size: 20)),
          ),
        ),
      ),
    ],
  );
}