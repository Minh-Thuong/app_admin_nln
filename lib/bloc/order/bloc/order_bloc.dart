import 'package:admin/models/order_model.dart';
import 'package:admin/models/order_status.dart';
import 'package:admin/repository/order_repository.dart';
import 'package:admin/service/invoice_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  late final OrderRepository _orderRepository;

  OrderBloc(OrderRepository orderRepository)
      : _orderRepository = orderRepository,
        super(OrderInitial()) {
    on<OrderGetList>(_onGetList);
    on<OrderGetDetail>(_onGetOrderDetail);
    on<OrderUpdateStatus>(_onUpdateStatus);
  }

  Future<void> _onGetList(OrderGetList event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getOrdersByStatus(event.status);
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: 'Tải danh sách order thất bại: $e'));
    }
  }

  Future<void> _onGetOrderDetail(
      OrderGetDetail event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await _orderRepository.getOrderById(event.orderId);
      emit(OrderDetailLoaded(order: order));
    } catch (e) {
      emit(OrderError(message: 'Tải chi tiết order thất bại: $e'));
    }
  }

  Future<void> _onUpdateStatus(
      OrderUpdateStatus event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order =
          await _orderRepository.updateStatus(event.orderId, event.status);
      emit(OrderStatusUpdated(order: order));
    } catch (e) {
      emit(OrderStatusUpdateError(
          message: 'Cập nhật trạng thái order thất bại: $e'));
    }
  }
}
