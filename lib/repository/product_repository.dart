import 'package:admin/models/paging_product.dart';
import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/models/product_model.dart';

abstract class IProductRepository {
  Future<List<Product>> getProducts(); // Phân trang
  Future<Product> createProduct(Product product);
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


}
