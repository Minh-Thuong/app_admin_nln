import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/datasource/category_datasource.dart';
import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/repository/category_repository.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:admin/screen/product/addproduct_screen.dart';
import 'package:admin/screen/product/product_category_screen.dart';
import 'package:admin/screen/product/product_gridview.dart';
import 'package:admin/screen/product/product_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductError) {
          return Center(child: Text("Lỗi: ${state.message}"));
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              elevation: 0,
              title: SizedBox(
                height: 40.h,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // nếu dùng BlocProvider.value thì khi chỉnh sửa xong
                        //quay trở về màn hình hình sản phẩm thì sẽ bị mất dữ liệu
                        builder: (_) => BlocProvider(
                          create: (_) => ProductBloc(
                            ProductsRepository(
                                ProductRemote(dio: DioClient.instance)),
                          )..add(LoadProducts()),
                          child: const ProductSearchScreen(),
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 8),
                      Icon(Icons.search, color: Colors.black54, size: 25),
                      SizedBox(width: 8),
                      Text(
                        "Tìm tên, mã SKU, ...",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Sản phẩm"),
                  Tab(text: "Danh mục"),
                ],
              ),
            ),
            body: Stack(
              children: [
                TabBarView(
                  children: [
                    if (state is ProductLoaded)
                      ProductGridView(
                        products: state.products,
                        onRefresh: () =>
                            context.read<ProductBloc>().add(LoadProducts()),
                      )
                    else
                      const Center(child: Text("Không có sản phẩm")),
                    BlocProvider(
                      create: (context) => CategoryBloc(
                        CategoriesRepository(
                            CategoryRemote(dio: DioClient.instance)),
                      )..add(LoadCategories()),
                      child: ProductCategoryScreen(
                        onRefresh: () {
                          context.read<CategoryBloc>().add(LoadCategories());
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 50.h,
                  right: 25.w,
                  child: FloatingActionButton(
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white)),
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
