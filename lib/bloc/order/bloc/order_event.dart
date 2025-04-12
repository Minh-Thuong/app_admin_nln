part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderGetList extends OrderEvent {
  final OrderStatus status;

  const OrderGetList({required this.status});

  @override
  List<Object> get props => [status];
}

class OrderGetDetail extends OrderEvent {
  final String orderId;

  const OrderGetDetail({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

class OrderUpdateStatus extends OrderEvent {
  final String orderId;
  final OrderStatus status;

  const OrderUpdateStatus({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object> get props => [orderId, status];
}