part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;

  const OrderLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}

class OrderDetailLoaded extends OrderState {
  final Order order;

  const OrderDetailLoaded({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderStatusUpdated extends OrderState {
  final Order order;

  const OrderStatusUpdated({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderStatusUpdateError extends OrderState {
  final String message;

  const OrderStatusUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class InvoiceLoaded extends OrderState {
  final List<List<String>> invoice;
  final double total;
  const InvoiceLoaded({required this.invoice, required this.total});

  @override
  // TODO: implement props
  List<Object> get props => [invoice];
}

class InvoiceError extends OrderState {
  final String message;
  InvoiceError(this.message);
}