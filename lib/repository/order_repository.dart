import 'package:admin/datasource/order_datasource.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/models/order_status.dart';

abstract class IOrderRepository {
  Future<List<Order>> getOrdersByStatus(OrderStatus status);
    Future<Order> getOrderById(String id);
    Future<Order> updateStatus(String orderId, OrderStatus status);
}

class OrderRepository extends IOrderRepository {
  final OrderDatasource _orderDatasource;

  OrderRepository(this._orderDatasource);


  @override
  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    try {
      return await _orderDatasource.getOrdersByStatus(status);
    } catch (e) {
      throw Exception('Tải danh sách order thất bại: $e');
    }
  }
  
  @override
  Future<Order> getOrderById(String id) async {
    try {
      return await _orderDatasource.getOrderById(id);
    } catch (e) {
      throw Exception('Tải order thất bại: $e');
    }
  }
  
  @override
  Future<Order> updateStatus(String orderId, OrderStatus status) async {
     try {
      return await _orderDatasource.updateStatus(orderId, status);
    } catch (e) {
      throw Exception('Tải order thất bại: $e');
    }
  }
}
