import 'package:admin/datasource/category_datasource.dart';
import 'package:admin/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class ICategoriesRepository {
  Future<List<Category>> getCategories();

  Future<Category> createCategory(String name, XFile image);
  Future<Category> updateCategory(
      String id, String name, XFile? image); // Cập nhật danh mục

  Future<void> deleteCategory(String id);
}

class CategoriesRepository extends ICategoriesRepository {
  final ICategoriesDatasource _categoriesDatasource;

  CategoriesRepository(this._categoriesDatasource);

  @override
  Future<Category> createCategory(String name, XFile image) async {
    try {
      final result = await _categoriesDatasource.createCategory(name, image);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final result = await _categoriesDatasource.getCategories();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Category> updateCategory(String id, String name, XFile? image) async {
    try {
      final result =
          await _categoriesDatasource.updateCategory(id, name, image);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _categoriesDatasource
          .deleteCategory(id); // Gọi phương thức xóa trong datasource
    } catch (e) {
      throw Exception("Xóa danh mục thất bại: ${e.toString()}");
    }
  }
}
