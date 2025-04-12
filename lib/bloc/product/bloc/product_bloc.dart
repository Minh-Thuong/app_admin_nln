import 'package:admin/models/product_model.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IProductRepository _productRepository;
  List<Product> _allProducts = [];

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProductRequest>(_onCreateProduct);
    on<UpdateProductRequest>(_onUpdateProduct);
    on<DeleteProductRequest>(_onDeleteProduct);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsByCategory>(_onFilterProductsByCategory);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    if (_allProducts.isNotEmpty) {
      emit(ProductLoaded(_allProducts));
      return;
    }
    emit(ProductLoading());
    try {
      _allProducts = await _productRepository.getProducts();
      emit(ProductLoaded(_allProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
      CreateProductRequest event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final newProduct = await _productRepository.createProduct(event.product);
      _allProducts.add(newProduct);
      emit(ProductCreated(newProduct));
      emit(ProductLoaded(_allProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProductRequest event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final updatedProduct =
          await _productRepository.updateProduct(event.product, event.newImage);
      final index = _allProducts.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        _allProducts[index] = updatedProduct;
      }
      emit(ProductUpdated(updatedProduct));
      // emit(ProductLoaded(_allProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProductRequest event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await _productRepository.deleteProduct(event.id);
      // _allProducts.removeWhere((p) => p.id == event.id);
      emit(ProductDeleted());
      // emit(ProductLoaded(_allProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final result = await _productRepository.searchProducts(
          event.query, event.page, event.limit);
      emit(ProductSearchResult(result));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFilterProductsByCategory(
      FilterProductsByCategory event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final result = await _productRepository.searchProductswithCategory(
          event.query, event.page, event.limit);
      emit(ProductSearchCategoryResult(result));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
