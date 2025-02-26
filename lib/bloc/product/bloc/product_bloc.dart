import 'package:admin/models/product_model.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IProductRepository _productRepository;
  List<Product> products = [];
  // final ProductDataSource productDataSource;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProductRequest>(_onCreateProduct);
    on<UpdateProductRequest>(_onUpdateProduct);
    on<DeleteProductRequest>(_ondeleteProduct);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final result = await _productRepository.getProducts();
      emit(ProductLoaded(result));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
      CreateProductRequest event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final result = await _productRepository.createProduct(event.product);
      emit(ProductCreated(result));
    } catch (e) {
      emit(ProductError(e.toString()));
      rethrow;
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProductRequest event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final result =
          await _productRepository.updateProduct(event.product, event.newImage);
      emit(ProductUpdated(result));
    } catch (e) {
      emit(ProductError(e.toString()));
      rethrow;
    }
  }

  Future<void> _ondeleteProduct(
      DeleteProductRequest event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await _productRepository.deleteProduct(event.id);
      final updatelistproduct = await _productRepository.getProducts();
      emit(ProductLoaded(updatelistproduct));
      emit(ProductDeleted());
    } catch (e) {
      emit(ProductError(e.toString()));
      rethrow;
    }
  }
}
