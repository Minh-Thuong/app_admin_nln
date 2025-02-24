import 'package:admin/models/product_model.dart';
import 'package:admin/util/token_manager.dart';

import 'package:dio/dio.dart';

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
    try {
      final response = dio.post(
        '/api/products',
      );
    } catch (e) {}
  }
}
