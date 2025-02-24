import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/screen/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductGridView extends StatefulWidget {
  const ProductGridView({super.key});

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
              context.read<ProductBloc>().add(LoadProducts());
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                if (index >= state.products.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ProductCard(product: state.products[index]);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
