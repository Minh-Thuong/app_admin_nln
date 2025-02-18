
import 'package:admin/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  ProductGridView({super.key});
  final List<Map<String, dynamic>> demoProducts = [
    {
      "name": "Product 1",
      "price": 10.99,
      "stockInfo": "In stock",
      "imageIcon": Icons.image,
    },
    {
      "name": "Phở bò",
      "price": 30000.0,
      "stockInfo": "Có thể bán: 98 | 1 tô",
      "imageIcon": Icons.restaurant_menu,
    },
    {
      "name": "Sản phẩm 3",
      "price": 45000.0,
      "stockInfo": "Có thể bán: 10 | 1 tô",
      "imageIcon": Icons.coffee,
    },
    {
      "name": "Product 1",
      "price": 10.99,
      "stockInfo": "In stock",
      "imageIcon": Icons.image,
    },
    {
      "name": "Phở bò",
      "price": 30000.0,
      "stockInfo": "Có thể bán: 98 | 1 tô",
      "imageIcon": Icons.restaurant_menu,
    },
    {
      "name": "Sản phẩm 3",
      "price": 45000.0,
      "stockInfo": "Có thể bán: 10 | 1 tô",
      "imageIcon": Icons.coffee,
    },
    {
      "name": "Product 1",
      "price": 10.99,
      "stockInfo": "In stock",
      "imageIcon": Icons.image,
    },
    {
      "name": "Phở bò",
      "price": 30000.0,
      "stockInfo": "Có thể bán: 98 | 1 tô",
      "imageIcon": Icons.restaurant_menu,
    },
    {
      "name": "Sản phẩm 3",
      "price": 45000.0,
      "stockInfo": "Có thể bán: 10 | 1 tô",
      "imageIcon": Icons.coffee,
    },
    {
      "name": "Product 1",
      "price": 10.99,
      "stockInfo": "In stock",
      "imageIcon": Icons.image,
    },
    {
      "name": "Phở bò",
      "price": 30000.0,
      "stockInfo": "Có thể bán: 98 | 1 tô",
      "imageIcon": Icons.restaurant_menu,
    },
    {
      "name": "Sản phẩm 3",
      "price": 45000.0,
      "stockInfo": "Có thể bán: 10 | 1 tô",
      "imageIcon": Icons.coffee,
    },
    {
      "name": "Product 1",
      "price": 10.99,
      "stockInfo": "In stock",
      "imageIcon": Icons.image,
    },
    {
      "name": "Phở bò",
      "price": 30000.0,
      "stockInfo": "Có thể bán: 98 | 1 tô",
      "imageIcon": Icons.restaurant_menu,
    },
    {
      "name": "Sản phẩm 3",
      "price": 45000.0,
      "stockInfo": "Có thể bán: 10 | 1 tô",
      "imageIcon": Icons.coffee,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: demoProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 0.8),
        itemBuilder: (context, index) {
          final product = demoProducts[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}