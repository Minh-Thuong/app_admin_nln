part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class RefreshProducts extends ProductEvent {}

class CreateProductRequest extends ProductEvent {
  final Product product;
  const CreateProductRequest(this.product);

  @override
  // TODO: implement props
  List<Object> get props => [product];
}