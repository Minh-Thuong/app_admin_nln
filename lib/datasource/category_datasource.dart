import 'package:admin/models/category_model.dart';
import 'package:admin/util/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class ICategoriesDatasource {
  Future<List<Category>> getCategories();

  Future<Category> createCategory(String name, XFile image);

  Future<Category> updateCategory(String id, String name, XFile? image);

  Future<void> deleteCategory(String id);
}

class CategoryRemote extends ICategoriesDatasource {
  final Dio dio;
  CategoryRemote({required this.dio});
  @override
  Future<Category> createCategory(String name, XFile image) async {
    final token = await TokenManager.getToken();

    // kiểm tra xem token hợp lệ hay không
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }
    // Tạo FormData để hỗ trợ ảnh
    FormData formData = FormData.fromMap({
      'name': name,
      'profileImage':
          await MultipartFile.fromFile(image.path, filename: image.name),
    });

    try {
// Gửi yêu cầu POST để tạo danh mục mới
      final response = await dio.post(
        '/api/categorys',
        data: formData, // tham số truyền vô
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // In phản hồi từ API để debug
      print("Phản hồi từ API: ${response.data}");
      print("Đang gửi dữ liệu: ${formData.fields}");
      print("Đang gửi ảnh: ${image.path}");

      //    // Kiểm tra nếu phản hồi thành công
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final result = response.data['result'];
        if (result != null && result is Map<String, dynamic>) {
          return Category.fromJson(result);
        } else {
          // Trường hợp nếu không nhận được dữ liệu hợp lệ từ API
          throw Exception(response.data['error']);
        }
      } else {
        // Kiểm tra lỗi từ API và hiển thị thông báo tương ứng
        if (response.data['error'] == 'Danh mục đã tồn tại') {
          throw Exception("Danh mục đã tồn tại");
        } else {
          throw Exception("API trả về lỗi: ${response.statusCode}");
        }
      }
    } catch (e) {
      // Xử lý các lỗi ngoài ý muốn, bao gồm lỗi kết nối mạng, server, v.v.
      throw Exception("Lỗi: ${e.toString()}");
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Token không hợp lệ");
      }

      final response = await dio.get(
        '/api/categorys',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['result'];
        print(results);
        return results.map((json) => Category.fromJson(json)).toList();
      }
      throw Exception("Không thể tải danh mục");
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Lỗi kết nối API");
    } catch (e) {
      throw Exception("Lỗi không xác định: ${e.toString()}");
    }
  }

  @override
  Future<Category> updateCategory(String id, String name, XFile? image) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Token không hợp lệ");
      }
      // Tạo FormData để gửi tên danh mục
      FormData formData = FormData.fromMap({
        'name': name, // Tên luôn được gửi
      });
      // Chỉ thêm ảnh nếu người dùng chọn ảnh mới
      if (image != null) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await MultipartFile.fromFile(image.path, filename: image.name),
          ),
        );
      }

      final response = await dio.put(
        '/api/categorys/$id',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      //    // Kiểm tra nếu phản hồi thành công
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final result = response.data['result'];
        if (result != null && result is Map<String, dynamic>) {
          return Category.fromJson(result);
        } else {
          // Trường hợp nếu không nhận được dữ liệu hợp lệ từ API
          throw Exception(response.data['error']);
        }
      } else {
        // Kiểm tra lỗi từ API và hiển thị thông báo tương ứng
        if (response.data['error'] == 'Danh mục đã tồn tại') {
          throw Exception("Danh mục đã tồn tại");
        } else {
          throw Exception("API trả về lỗi: ${response.statusCode}");
        }
      }
    } catch (e) {
      // Xử lý các lỗi ngoài ý muốn, bao gồm lỗi kết nối mạng, server, v.v.
      throw Exception("Lỗi: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }

    final response = await dio.delete(
      '/api/categorys/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Xóa danh mục thất bại");
    }
  }
}
