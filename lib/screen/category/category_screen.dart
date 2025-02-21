import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/datasource/category_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/repository/category_repository.dart';
import 'package:admin/screen/category/create_category_screen.dart';
import 'package:admin/widgets/gridview_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.instance;
    final categoriesDatasource = CategoryRemote(dio: dio);
    final categoriesRepository = CategoriesRepository(categoriesDatasource);

    return BlocProvider(
      create: (context) =>
          CategoryBloc(categoriesRepository)..add(LoadCategories()),
      child: Builder(builder: (builderContext) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Danh mục"),
            backgroundColor: Colors.green,
          ),
          body: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryError) {
                return Center(child: Text('Lỗi: ${state.message}'));
              }
              if (state is CategoryLoaded) {
                final categories = state.categories;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      // mainAxisSpacing: 8,
                      // crossAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final category =
                          categories[index]; // Get category at current index
                      print("Category at index $index: $category");

                      return Column(
                        children: [
                          // Hình ảnh của danh mục
                          Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: category.profileImage != null
                                  ? DecorationImage(
                                      image:
                                          NetworkImage(category.profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: category.profileImage == null
                                ? Center(child: Icon(Icons.image_not_supported))
                                : null, // Optional: fallback when no image
                          ),
                          // Tên danh mục
                          Text(
                            category.name ??
                                'Tên không có', // Display default text if null
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
              return Center(child: Text("Không có danh mục"));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                builderContext,
                MaterialPageRoute(
                  builder: (context) => const CreateCategoryScreen(),
                ),
              );
              //    Nếu tạo category thành công, tải lại danh sách
              if (result == true) {
                if (builderContext.mounted) {
                  // Kiểm tra context còn tồn tại
                  builderContext.read<CategoryBloc>().add(LoadCategories());
                }
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }

 
}
