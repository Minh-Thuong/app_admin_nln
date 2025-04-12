import 'package:admin/bloc/product/bloc/product_bloc.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode để kiểm soát focus
  String currentQuery = "";
  int page = 0;
  int limit = 10;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: SizedBox(
          height: 40.h,
          child: TextField(
            controller: _searchController,
            onSubmitted: (query) {
              setState(() {
                currentQuery = query;
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
          if (state is ProductSearchResult) {
            return ProductGridView(
              products: state.products,
              onRefresh: () => context.read<ProductBloc>().add(
                    SearchProducts(currentQuery, page, limit),
                  ),
            );
          }
          if (state is ProductLoaded) {
            return ProductGridView(
              products: state.products,
              onRefresh: () => context.read<ProductBloc>().add(LoadProducts()),
            );
          }
          return const Center(child: Text("Nhập từ khóa để tìm kiếm"));
        },
      ),
    );
  }
}
