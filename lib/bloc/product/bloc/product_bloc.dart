import 'dart:math';
import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/models/paging_product.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IProductRepository _productRepository;
  // final ProductDataSource productDataSource;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
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


}
