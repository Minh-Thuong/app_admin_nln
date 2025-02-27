import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/screen/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductGridView extends StatefulWidget {
  final VoidCallback onRefresh;
  const ProductGridView({super.key, required this.onRefresh});

  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInitial) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is ProductError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is ProductLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              widget.onRefresh();
            },
            child: CustomScrollView(
              cacheExtent:
                  2000, //Giữ widget trong phạm vi 2000 pixel ngoài màn hình
              controller: _scrollController,
              slivers: [
                // SliverGrid sử dụng grid delegate để điều khiển lưới
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProductCard(
                          product: state.products[index],
                          onRefresh: widget.onRefresh);   // Truyền callback xuống ProductCard
                    },
                    childCount: state.products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Số cột trong grid
                    mainAxisSpacing:
                        8.0, // Khoảng cách giữa các phần tử theo chiều dọc
                    crossAxisSpacing:
                        8.0, // Khoảng cách giữa các phần tử theo chiều ngang
                    childAspectRatio:
                        0.7, // Tỉ lệ chiều cao của các mục trong grid
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
