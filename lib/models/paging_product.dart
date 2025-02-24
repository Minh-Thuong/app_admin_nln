import 'package:admin/models/product_model.dart';

class PaginatedProducts {
  final List<Product> products;
  final Pagination pagination;

  PaginatedProducts({required this.products, required this.pagination});
}

class Pagination {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  Pagination({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      size: json['size'],
      number: json['number'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}