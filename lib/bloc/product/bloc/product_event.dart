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

class UpdateProductRequest extends ProductEvent {
  final Product product;
  final XFile? newImage;
  const UpdateProductRequest(this.product, this.newImage);

  @override
  List<Object> get props => [product, newImage ?? Object()];
}

class DeleteProductRequest extends ProductEvent {
  final String id;
  const DeleteProductRequest({required this.id});
}

class SearchProducts extends ProductEvent {
  final String query;
  final int page;
  final int limit;
  const SearchProducts(this.query, this.page, this.limit);
}
