import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/models/product_model.dart';
import 'package:image_picker/image_picker.dart';


abstract class IProductRepository {
  Future<List<Product>> getProducts(); // Phân trang
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product, XFile? newImage);
  Future<void> deleteProduct(String id);
  Future<List<Product>> searchProducts(String query, int page, int limit);
}

class ProductsRepository implements IProductRepository {
  final ProductDataSource _productDatasource;

  ProductsRepository(this._productDatasource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final result = await _productDatasource.getProducts();
      return result;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<Product> createProduct(Product product) async {
   try {
     final result = await _productDatasource.createProduct(product);
     return result;
   } catch (e) {
     rethrow;
   }
  }
  
  @override
  Future<Product> updateProduct(Product product, XFile? newImage) async {
   try {
     return _productDatasource.updateProduct(product, newImage);
   } catch (e) {
     rethrow;
   }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _productDatasource.deleteProduct(id);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<List<Product>> searchProducts(String query, int page, int limit) {
    try {
      return _productDatasource.searchProducts(query, page, limit);
    } catch (e) {
      rethrow;
    }
  }

}
