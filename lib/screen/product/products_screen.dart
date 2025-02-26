import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/screen/product/addproduct_screen.dart';
import 'package:admin/screen/product/product_gridview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductError) {
          return Center(child: Text("Lỗi: ${state.message}"));
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              elevation: 0,
              title: SizedBox(
                height: 40.h,
                child: TextField(
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
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Sản phẩm"),
                  Tab(text: "Bán kèm"),
                  Tab(text: "Tồn kho"),
                ],
              ),
            ),
            body: Stack(
              children: [
                const TabBarView(
                  children: [
                    ProductGridView(),
                    Center(child: Text("Tồn kho")),
                    Center(child: Text("Bán kèm")),
                  ],
                ),
                Positioned(
                  bottom: 50.h,
                  right: 25.w,
                  child: FloatingActionButton(
                    shape: const CircleBorder(side: BorderSide(color: Colors.white)),
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductScreen(),
                        ),
                      );
                      if (result == true && context.mounted) {
                        context.read<ProductBloc>().add(LoadProducts());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
