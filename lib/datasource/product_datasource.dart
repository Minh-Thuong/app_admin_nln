import 'package:admin/models/product_model.dart';
import 'package:admin/util/token_manager.dart';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

abstract class ProductDataSource {
  Future<List<Product>> getProducts();
  Future<Product> createProduct(Product product);
}

class ProductRemote implements ProductDataSource {
  final Dio dio;

  ProductRemote({required this.dio});

  @override
  Future<List<Product>> getProducts({int page = 0, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/api/products',
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['result'];
        print(results); // Kiểm tra dữ liệu
        return results.map((product) => Product.fromJson(product)).toList();
      }
      throw Exception("Không thể tải sản phẩm");
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Lỗi kết nối API");
    } catch (e) {
      throw Exception("Lỗi không xác định: ${e.toString()}");
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }

    // Lấy đường dẫn ảnh
  String profileImagePath = product.profileImage ?? '';

    FormData formData = FormData.fromMap({
      'name': product.name,
      'price': product.price, // giá bán
      'description': product.description,
      'sale': product.sale, // giá nhập
      'stock': product.stock,
      'category': product.categoryId,
      'profileImage': profileImagePath.isNotEmpty
        ? await MultipartFile.fromFile(profileImagePath, filename: profileImagePath.split('/').last)
        : null,  // Tải ảnh lên nếu có
    });
    try {
      final response = await dio.post('/api/products',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ));

      print("Đang gửi dữ liệu: ${formData.fields}");
       print("Đang gửi ảnh: ${profileImagePath}");


      if (response.statusCode == 200) {
        final results = response.data['result'];
        print(results); // Kiểm tra dữ liệu
        if (results != null && results is Map<String, dynamic>) {
          return Product.fromJson(results);
        }
      } else {
        // Kiểm tra lỗi từ API và hiển thị thông báo tương ứng
        if (response.data['error'] == 'Sản phẩm đã tồn tại') {
          throw Exception("Sản phẩm đã tồn tại");
        } else {
          throw Exception("API trả về lỗi: ${response.statusCode}");
        }
      }
      throw Exception("Không thể tải sản phẩm");
    } catch (e) {
      // Xử lý các lỗi ngoài ý muốn, bao gồm lỗi kết nối mạng, server, v.v.
      throw Exception("Lỗi: ${e.toString()}");
    }
  }
}
