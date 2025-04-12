part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

final class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductCreated extends ProductState {
  final Product product;
  const ProductCreated(this.product);

  @override
  List<Object> get props => [product];
}

class ProductUpdated extends ProductState {
  final Product product;
  const ProductUpdated(this.product);

  @override
  List<Object> get props => [product];
}

class ProductDeleted extends ProductState {}

class ProductSearchResult extends ProductState {
  final List<Product> products;
  const ProductSearchResult(this.products);

  @override
  List<Object> get props => [products];
}

class ProductSearchCategoryResult extends ProductState {
  final List<Product> products;

  const ProductSearchCategoryResult(this.products);

  @override
  List<Object> get props => [products];
}