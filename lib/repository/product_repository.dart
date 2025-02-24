import 'package:admin/models/paging_product.dart';
import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/models/product_model.dart';

abstract class IProductRepository {
  Future<List<Product>> getProducts(); // Phân trang
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
}
