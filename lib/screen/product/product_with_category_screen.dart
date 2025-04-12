import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/screen/product/product_gridview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductWithCategoryScreen extends StatefulWidget {
  final Category category;
  const ProductWithCategoryScreen({super.key, required this.category});

  @override
  State<ProductWithCategoryScreen> createState() =>
      _ProductWithCategoryScreenState();
}

class _ProductWithCategoryScreenState extends State<ProductWithCategoryScreen> {
  int page = 0;
  int limit = 10;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<CategoryBloc>().add(LoadCategories());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: SizedBox(height: 40.h, child: Text(widget.category.name)),
        ),
        body: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProductError) {
                return Center(child: Text(state.message));
              }
              if (state is ProductSearchCategoryResult) {
                return ProductGridView(
                  products: state.products,
                  onRefresh: () => context.read<ProductBloc>().add(
                        FilterProductsByCategory(
                            widget.category.id, page, limit),
                      ),
                );
              }
              return const Center(
                  child: Text("Không có sản phẩm trong danh mục này"));
            },
          ),
        ),
      ),
    );
  }
}
