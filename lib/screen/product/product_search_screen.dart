import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:admin/screen/product/product_gridview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    String currentQuery = ""; // Lưu từ khóa hiện tại
    int page = 0; // Lưu trang hiện tại
    int limit = 10; // Lưu giới hạn hiện tại
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: SizedBox(
          height: 40.h, // Hoặc bất kỳ chiều cao nào mà bạn muốn
          child: TextField(
            controller: searchController,
            onSubmitted: (query) {
              setState(() {
                currentQuery = query; // Cập nhật từ khóa hiện tại
              });
              context
                  .read<ProductBloc>()
                  .add(SearchProducts(currentQuery, page, limit));
            },
            decoration: InputDecoration(
              hintText: "Tìm tên, mã SKU, ...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          if (state is ProductLoaded) {
            return ProductGridView(
              onRefresh: () => context.read<ProductBloc>().add(LoadProducts()),
            );
          }

          return const Center(child: Text("Nhập từ khóa để tìm kiếm"));
        },
      ),
    );
  }
}
