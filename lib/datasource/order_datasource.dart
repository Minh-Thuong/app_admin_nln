import 'package:admin/models/order_model.dart';
import 'package:admin/models/order_status.dart';
import 'package:admin/util/token_manager.dart';
import 'package:dio/dio.dart';

abstract class IOrderDatasource {
  Future<List<Order>> getOrdersByStatus(OrderStatus status);
  Future<Order> getOrderById(String id);
  Future<Order> updateStatus(String orderId, OrderStatus status);
}

class OrderDatasource extends IOrderDatasource {
  final Dio _dio;

  OrderDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }

    try {
      final statusString = status.name;
      final response = await _dio.get(
        '/api/orders/status/$statusString',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        final List<dynamic> result = response.data;

        return result.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Cập nhật trang thái thất bại');
      }
    } catch (e) {
      throw Exception('Cập nhật trang thái thất bại: $e');
    }
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }

    try {
      final response = await _dio.get(
        '/api/orders/$orderId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Tải đơn hàng thất bại');
      }
    } catch (e) {
      throw Exception('Tải đơn hàng thất bại: $e');
    }
  }
  
  @override
  Future<Order> updateStatus(String orderId, OrderStatus status) async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }

    try {
      final response = await _dio.put(
        '/api/orders/$orderId/update-status',
        data: {'status': status.name},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Cập nhật trang thái thất bại');
      }
    } catch (e) {
      throw Exception('Cập nhật trang thái thất bại: $e');
    }
  }

}
