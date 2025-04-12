import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:admin/screen/product/product_with_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ProductCategoryScreen extends StatelessWidget {
//   final VoidCallback onRefresh;
//   const ProductCategoryScreen({super.key, required this.onRefresh});

// }

class ProductCategoryScreen extends StatefulWidget {
  final VoidCallback onRefresh;
  const ProductCategoryScreen({super.key, required this.onRefresh});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryInitial || state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CategoryError) {
          return const Center(child: Text("Không thể tải danh mục"));
        }
        if (state is CategoryLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CategoryBloc>().add(LoadCategories());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CustomScrollView(
                cacheExtent: 2000,
                slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cat = state.categories[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => ProductBloc(
                                    ProductsRepository(
                                        ProductRemote(dio: DioClient.instance)),
                                  )..add(
                                      FilterProductsByCategory(cat.id, 0, 10)),
                                  child:
                                      ProductWithCategoryScreen(category: cat),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: cat.profileImage != null
                                      ? DecorationImage(
                                          image:
                                              NetworkImage(cat.profileImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: cat.profileImage == null
                                    ? const Center(
                                        child: Icon(Icons.image_not_supported))
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  cat.name ?? 'Tên không có',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: state.categories.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
